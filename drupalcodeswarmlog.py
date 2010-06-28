#!/usr/bin/python

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

def get_git_changes(repo, commit_id):
    #git whatchanged -1 --format="%an" $HASH
    return repo.git.whatchanged(commit_id, "-1", format="%an")

def get_changes(git_changes):
    #grep ^:| cut -f 2 | while read FILE; do
    changes = []
    for line in git_changes.split("\n"):
       if line.startswith(":"):
           changes.append(line.split("\t")[1])
    return changes

def get_authors(subject):
    #php_pattern = '/(?<authors>by [\w\d\s,.]+:)/'
    pattern = r"by (?P<raw_authors>[\w\d\s,.]+):"
    matches = re.search(pattern, subject)
    if matches is None:
        return
    raw_authors = matches.group("raw_authors").split(",")
    authors = []
    for raw_author in raw_authors:
        raw_author = raw_author.strip()
        # try to avoid common non-standard messages once(non recursive)
        pos1 = raw_author.find("et al")
        pos2 = raw_author.find(" and ")
        if pos1 != -1:
            raw_author = raw_author.replace("et all", "").strip()
            raw_author = raw_author.replace("et al", "").strip()
            if raw_author != '':
                authors.append(raw_author)
        elif pos2 != -1:
            raw_author1, raw_author2 = raw_author.split(" and ")
            raw_author1 = raw_author1.strip()
            raw_author2 = raw_author2.strip()
            if raw_author1 != '':
                authors.append(raw_author1)
            if raw_author2 != '':
                authors.append(raw_author2.strip())
        elif raw_author.startswith("and "):
            raw_author = raw_author[4:].strip()
            if raw_author != '':
                authors.append(raw_author)
        elif raw_author.strip() != '':
            authors.append(raw_author.strip())
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

if __name__ == "__main__":
    main()
