#!/usr/bin/python

import git, re

def get_git_log(repo, target):
    return repo.git.log("--all", "--reverse", target, date="iso", format="%H\t%at\t%an\t%s")

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
    commit_before_d7_start='703488e5c5daf2c917c2d114d7946bc3a206519d'
    #target = "master"
    target = commit_before_d7_start + "..master"

    repo = git.Repo('/home/marvil/sandbox/drupalcodeswarm/core')

    # get git output
    git_log = get_git_log(repo, target)

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

main()
