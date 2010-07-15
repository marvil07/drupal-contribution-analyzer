#!/usr/bin/python
"""
The script that writes codeswarm xml.
"""

from optparse import OptionParser
import git, re, os, sys

"""
Return a special git-log output of the repo and using target.
"""
def get_git_log(repo, target, whole_history=False):
    if whole_history:
        return repo.git.log(target, "--all", "--reverse", date="iso", format="%H\t%at\t%an\t%s")
    else:
        return repo.git.log(target, "--reverse", date="iso", format="%H\t%at\t%an\t%s")

"""
Return one commit_id git-whatchanged output of the repo.
"""
def get_git_changes(repo, commit_id):
    #git whatchanged -1 --format="%an" $HASH
    return repo.git.whatchanged(commit_id, "-1", format="%an")

"""
Process git-whatchanged ouput and return the list of files relevant to
the commit.
"""
def get_changes(git_changes):
    #grep ^:| cut -f 2 | while read FILE; do
    changes = []
    for line in git_changes.split("\n"):
       if line.startswith(":"):
           changes.append(line.split("\t")[1])
    return changes

"""
Take a one-line comit message and return a list of string with one
author per item.

The standard message should look like:
  [issue category] #[issue number] by [comma-separated usernames]: [Short summary of the change].

This is a list of example input subjects:
- "#645790 by arianek, jhodgdon, and lisarex: Convert Locale module to new help standard."
- "#645790: Convert Locale module to new help standard."
- "by arianek, jhodgdon, and lisarex: Convert Locale module to new help standard."
- "- Patch #88892 by darthsteven et al: improved the PHPdoc of form_set_value().  Great work.  Much better. :)"
- "#198579 by webernet and hswong3i: a huge set of coding style fixes, including:"
- "#193274 by dmitrig01 and quicksketch: send submit button data with AHAH submissions"
- "#601806 by sun, effulgentsia, and Damien Tournoud: drupal_render() should not set default element properties that make no sense."
- "#307477 by clemens.tolboom and boombatower: Test how XML-RPC responds to large messages."
- "Patch #164532 by catch, pwolanin, David Strauss, et al.: improve table indicies for common queries."
"""
def get_authors(subject):
    pattern = r"by (?P<raw_authors>[\w\d\s,.]+):"
    matches = re.search(pattern, subject)
    # if checking invalid_strings affects performance, take invalid
    # messages out grepping `author="<something>"`
    invalid_strings = ["", "me", "myself",
        "their authors",
        "in the following manner",
        "going to http",
        "improve to the core doxygen PHPdoc",
        "after coding style fixes",
        ]
    strip_chars = ". "
    if matches is None:
        return
    raw_authors = matches.group("raw_authors").split(",")
    authors = []
    for raw_author in raw_authors:
        raw_author = raw_author.strip()
        # try to avoid common non-standard messages once(non recursive)
        pos1 = raw_author.find("et al")
        pos2 = raw_author.find(" and ")
        # the following can be moved to a post-process grep if
        # performance is affected
        pos3 = raw_author.find("slightly")
        pos4 = raw_author.find("people")
        pos5 = raw_author.find("contributor")
        pos6 = raw_author.find("by ")

        if pos1 != -1:
            raw_author = raw_author.replace("et all", "").strip(strip_chars)
            raw_author = raw_author.replace("et al", "").strip(strip_chars)
            if raw_author not in invalid_strings:
                authors.append(raw_author)
        elif pos2 != -1:
            raw_author1, raw_author2 = raw_author.split(" and ")
            raw_author1 = raw_author1.strip(strip_chars)
            raw_author2 = raw_author2.strip(strip_chars)
            if raw_author1 not in invalid_strings:
                authors.append(raw_author1)
            if raw_author2 not in invalid_strings:
                authors.append(raw_author2)
        elif raw_author.startswith("and "):
            raw_author = raw_author[4:].strip(strip_chars)
            if raw_author not in invalid_strings:
                authors.append(raw_author)
        elif pos3 != -1:
            raw_author = raw_author.replace("slightly modified", "").strip(strip_chars)
            raw_author = raw_author.replace("slightly extended", "").strip(strip_chars)
            if raw_author not in invalid_strings:
                authors.append(raw_author)
        elif pos4 != -1:
            raw_author = raw_author.replace("various people", "").strip(strip_chars)
            raw_author = raw_author.replace("several people", "").strip(strip_chars)
            if raw_author not in invalid_strings:
                authors.append(raw_author)
        elif pos5 != -1:
            raw_author = raw_author.replace("numerous contributors", "").strip(strip_chars)
            raw_author = raw_author.replace("multiple contributors", "").strip(strip_chars)
            if raw_author not in invalid_strings:
                authors.append(raw_author)
        elif pos6 != -1:
            raw_author = raw_author[pos6+2:].strip(strip_chars)
            if raw_author not in invalid_strings:
                authors.append(raw_author)
        elif raw_author.strip(strip_chars) not in invalid_strings:
            authors.append(raw_author.strip(strip_chars))
    return authors

def main():

    # handling argv
    usage = "usage: %prog [options] path [target]\n"\
    "  path is the local clone of the drupalfr git repository\n"\
    "  target is the argument passed to git-log as <since>..<until>"
    parser = OptionParser(usage=usage)
    parser.add_option("-o", "--output", metavar="FILE", dest="filename",
            help="write output to FILE")
    parser.add_option("-a", "--full-history", action="store_true", dest="full_history",
            help="Use `--all` at git-log. This option is incompatible with target argument")
    (options, args) = parser.parse_args()
    if options.full_history:
        if len(args) != 1:
            parser.error("Incorrect number of arguments.\n"
            "If you provide -a you can not set the target since\n"
            "git-log anyway is going to retrieve whole history")
        target = 'master'
    else:
        if len(args) != 2:
            parser.error("Incorrect number of arguments.")
        target = args[1]
    if options.filename is not None:
        sys.stdout = open(options.filename, 'w')

    path_to_repo = os.path.abspath(args[0])
    repo = git.Repo(path_to_repo)

    # get git output
    git_log = get_git_log(repo, target, options.full_history)

    print '<?xml version="1.0"?>\n<file_events>'

    for log_line in git_log.splitlines():
        commit_id, timestamp, commiter, subject = log_line.split("\t")
        git_changes = get_git_changes(repo, commit_id)
        changes = get_changes(git_changes)
        for commited_file in changes:
            print '<event date="' + timestamp + '000" filename="/cvs/drupal/drupal/' + commited_file + '" author="' + commiter + '" />'
            # process each author parsing subject
            authors = get_authors(subject)
            if authors is not None:
                for author in authors:
                    print '<event date="' + timestamp + '000" filename="/cvs/drupal/drupal/' + commited_file + '" author="' + author + '" />'

    print '</file_events>'

    """
    At post-process we need to take care of non-standard messages,
    replacing:
    - simple author replace by errors:
        "Alexander.  You can use this script   to check your code against the Drupal coding style": Alexander
        "Jeremy to fix a module loading bug": Jeremy
        "with help from Nick": Nick
        "Ax to fixe": Ax
        "Usability Poobah Chris": factoryjoe
        "with help from Nick": Nick
        "Jose A Reyero with further cleanup by myself": Jose Reyero
        "kkaefer with fixes from myself": kkaefer
        "with help from Kristi Wachter": Kristi Wachter
        "in patch form by Rob Loach": Rob Loach
    - simple author replace by identification:
        "Damien": Damien Tournoud
        "DamZ": Damien Tournoud
    - split one line in two:
        "Mathias with help from Steven": Mathias, Steven
        "keith.smith based on initial suggestions from O Govinda": keith.smith, O Govinda
    - join same names with different capitalization
    """

if __name__ == "__main__":
    main()
