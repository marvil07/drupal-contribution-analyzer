include config.mk

# d7 target
TARGET=703488e5c5daf2c917c2d114d7946bc3a206519d..master
TIMEWARNING=Making the logs is a time consuming operation, please be patient.
D7LOGS=data/logs/drupal7-git-logs.xml
FULLLOGS=data/logs/drupalfull-git-logs.xml
STATSDIR=data/stats

all: doc

clean:
	rm -f \
		README.html \
		$(D7LOGS) \
		$(FULLLOGS) \
		$(STATSDIR)/drupal7-dev-participation-by-file-changes.txt \
		$(STATSDIR)/drupalfull-dev-participation-by-file-changes.txt \
		$(STATSDIR)/drupal7-dev-participation-by-commits.txt \
		$(STATSDIR)/drupalfull-dev-participation-by-commits.txt

doc: README.html
README.html: README.asciidoc
	asciidoc -a data-uri -a icons -a iconsdir=/etc/asciidoc/images/icons -o README.html README.asciidoc

drupal-core-git-repo:
	git clone -l $(DRUPALCORE) drupal-core-git-repo

data-dirs:
	mkdir -p data/logs
	mkdir -p data/stats

$(D7LOGS): drupal-core-git-repo data-dirs
	@echo "creating D7 logs"
	@echo $(TIMEWARNING)
	python drupalcodeswarmlog.py drupal-core-git-repo $(TARGET) | sed -f post-process.sed > $(D7LOGS)

$(FULLLOGS): drupal-core-git-repo data-dirs
	@echo "creating whole history logs"
	@echo $(TIMEWARNING)
	python drupalcodeswarmlog.py -a drupal-core-git-repo | sed -f post-process.sed > $(FULLLOGS)

mainlogs: $(D7LOGS) $(FULLLOGS)

filelog-count: mainlogs
	./prepare_tag_output.sh file-activity $(D7LOGS) > $(STATSDIR)/drupal7-dev-participation-by-file-changes.txt
	./prepare_tag_output.sh file-activity $(FULLLOGS) > $(STATSDIR)/drupalfull-dev-participation-by-file-changes.txt
commitlog-count: mainlogs
	./prepare_tag_output.sh commit-activity $(D7LOGS) > $(STATSDIR)/drupal7-dev-participation-by-commits.txt
	./prepare_tag_output.sh commit-activity $(FULLLOGS) > $(STATSDIR)/drupalfull-dev-participation-by-commits.txt
