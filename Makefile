include config.mk

# d7 target
TARGET=703488e5c5daf2c917c2d114d7946bc3a206519d..master
TIMEWARNING=Making the logs is a time consuming operation, please be patient.

all: doc

clean:
	rm README.html

doc: README.html
README.html: README
	asciidoc -a data-uri -a icons -a iconsdir=/etc/asciidoc/images/icons -o README.html README

drupal-core-git-repo:
	git clone -l $(DRUPALCORE) drupal-core-git-repo
	./generatelogs.sh drupal-core-git-repo

mainlogs: drupal7-git-logs.xml drupalfull-git-logs.xml

drupal7-git-logs.xml: drupal-core-git-repo
	@echo "creating D7 logs"
	@echo $(TIMEWARNING)
	python drupalcodeswarmlog.py drupal-core-git-repo $(TARGET) | sed -f post-process.sed > drupal7-git-logs.xml

drupalfull-git-logs.xml: drupal-core-git-repo
	@echo "creating whole history logs"
	@echo $(TIMEWARNING)
	python drupalcodeswarmlog.py -a drupal-core-git-repo | sed -f post-process.sed > drupalfull-git-logs.xml

filelog-count: mainlogs
	./prepare_tag_output.sh file-activity drupal7-git-logs.xml > drupal7-dev-participation-by-files.txt
	./prepare_tag_output.sh file-activity drupalfull-git-logs.xml > drupalfull-dev-participation-by-files.txt
commitlog-count: mainlogs
	./prepare_tag_output.sh commit-activity drupal7-git-logs.xml > drupal7-dev-participation-by-commits.txt
	./prepare_tag_output.sh commit-activity drupalfull-git-logs.xml > drupalfull-dev-participation-by-commits.txt
