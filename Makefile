include config.mk

# d7 target
D7TARGET=703488e5c5daf2c917c2d114d7946bc3a206519d..DRUPAL-7-0
TIMEWARNING=Making the logs is a time consuming operation, please be patient.
D7LOGS=data/logs/drupal7-git-logs.xml
FULLLOGS=data/logs/drupalfull-git-logs.xml

all: doc data/logs data/stats filelog-count commitlog-count tagclouds

data/logs:
	mkdir -p data/logs
data/stats:
	mkdir -p data/stats
data/tagclouds:
	mkdir -p data/tagclouds

clean:
	rm -f \
		README.html \
		$(D7LOGS) \
		$(FULLLOGS) \
		data/stats/drupal7-dev-participation-by-file-changes.txt \
		data/stats/drupalfull-dev-participation-by-file-changes.txt \
		data/stats/drupal7-dev-participation-by-commits.txt \
		data/stats/drupalfull-dev-participation-by-commits.txt

doc: README.html
README.html: README.asciidoc
	asciidoc -a data-uri -a icons -a iconsdir=/etc/asciidoc/images/icons -o README.html README.asciidoc

drupal-core-git-repo:
	git clone -l $(DRUPALCORE) drupal-core-git-repo

$(D7LOGS): drupal-core-git-repo data/logs
	@echo ": creating D7 logs"
	@echo $(TIMEWARNING)
	python drupalcodeswarmlog.py drupal-core-git-repo $(D7TARGET) | sed -f post-process.sed > $(D7LOGS)

$(FULLLOGS): drupal-core-git-repo data/logs
	@echo ": creating whole history logs"
	@echo $(TIMEWARNING)
	python drupalcodeswarmlog.py -a drupal-core-git-repo | sed -f post-process.sed > $(FULLLOGS)

filelog-count: filelog-count-d7 filelog-count-full
filelog-count-full: data/stats/drupalfull-dev-participation-by-file-changes.txt data/stats/drupalfull-dev-participation-by-file-changes-no-committers.txt
filelog-count-d7: data/stats/drupal7-dev-participation-by-file-changes.txt data/stats/drupal7-dev-participation-by-file-changes-no-committers.txt
data/stats/drupal7-dev-participation-by-file-changes.txt: $(D7LOGS) data/stats
	./prepare_tag_output.sh file-activity $(D7LOGS) > data/stats/drupal7-dev-participation-by-file-changes.txt
data/stats/drupalfull-dev-participation-by-file-changes.txt: $(FULLLOGS) data/stats
	./prepare_tag_output.sh file-activity $(FULLLOGS) > data/stats/drupalfull-dev-participation-by-file-changes.txt
data/stats/drupal7-dev-participation-by-file-changes-no-committers.txt: data/stats/drupal7-dev-participation-by-file-changes.txt
	egrep -v '(Dries|webchick)' data/stats/drupal7-dev-participation-by-file-changes.txt > data/stats/drupal7-dev-participation-by-file-changes-no-committers.txt
data/stats/drupalfull-dev-participation-by-file-changes-no-committers.txt: data/stats/drupalfull-dev-participation-by-file-changes.txt
	egrep -v '(Dries|drumm|Gábor Hojtsy|jeroen|killes|kjartan|natrak|Steven|webchick)' data/stats/drupalfull-dev-participation-by-file-changes.txt > data/stats/drupalfull-dev-participation-by-file-changes-no-committers.txt

commitlog-count: commitlog-count-full commitlog-count-d7
commitlog-count-full: data/stats/drupalfull-dev-participation-by-commits.txt data/stats/drupalfull-dev-participation-by-commits-no-committers.txt
commitlog-count-d7: data/stats/drupal7-dev-participation-by-commits.txt data/stats/drupal7-dev-participation-by-commits-no-committers.txt
data/stats/drupal7-dev-participation-by-commits.txt: $(D7LOGS) data/stats
	./prepare_tag_output.sh commit-activity $(D7LOGS) > data/stats/drupal7-dev-participation-by-commits.txt
data/stats/drupalfull-dev-participation-by-commits.txt: $(FULLLOGS) data/stats
	./prepare_tag_output.sh commit-activity $(FULLLOGS) > data/stats/drupalfull-dev-participation-by-commits.txt
data/stats/drupal7-dev-participation-by-commits-no-committers.txt: data/stats/drupal7-dev-participation-by-commits.txt
	egrep -v '(Dries|webchick)' data/stats/drupal7-dev-participation-by-commits.txt > data/stats/drupal7-dev-participation-by-commits-no-committers.txt
data/stats/drupalfull-dev-participation-by-commits-no-committers.txt: data/stats/drupalfull-dev-participation-by-commits.txt
	egrep -v '(Dries|drumm|Gábor Hojtsy|jeroen|killes|kjartan|natrak|Steven|webchick)' data/stats/drupalfull-dev-participation-by-commits.txt > data/stats/drupalfull-dev-participation-by-commits-no-committers.txt

tagclouds: tagclouds-d7 tagclouds-full
tagcloud-base: data/tagclouds TagCloud/application.linux/TagCloud
TagCloud/application.linux/TagCloud: doc
	@echo ": Manual generation of TagCloud binary"
	@echo "Please create the TagCloud binary, see README.html for details."
	@echo "Tagclouds will not be generated until you get the tagcloud binary in place."
tagclouds-d7: commitlog-count-d7 filelog-count-d7 data/tagclouds/drupal7-dev-participation-by-commits-no-committers.txt.tif data/tagclouds/drupal7-dev-participation-by-commits.txt.tif data/tagclouds/drupal7-dev-participation-by-file-changes-no-committers.txt.tif data/tagclouds/drupal7-dev-participation-by-file-changes.txt.tif
tagclouds-full: commitlog-count-full filelog-count-full data/tagclouds/drupalfull-dev-participation-by-commits-no-committers.txt.tif data/tagclouds/drupalfull-dev-participation-by-commits.txt.tif data/tagclouds/drupalfull-dev-participation-by-file-changes-no-committers.txt.tif data/tagclouds/drupalfull-dev-participation-by-file-changes.txt.tif
data/tagclouds/drupal7-dev-participation-by-commits-no-committers.txt.tif: tagcloud-base data/stats/drupal7-dev-participation-by-commits-no-committers.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupal7-dev-participation-by-commits-no-committers.txt
data/tagclouds/drupal7-dev-participation-by-commits.txt.tif: tagcloud-base data/stats/drupal7-dev-participation-by-commits.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupal7-dev-participation-by-commits.txt
data/tagclouds/drupal7-dev-participation-by-file-changes-no-committers.txt.tif: tagcloud-base data/stats/drupal7-dev-participation-by-file-changes-no-committers.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupal7-dev-participation-by-file-changes-no-committers.txt
data/tagclouds/drupal7-dev-participation-by-file-changes.txt.tif: tagcloud-base data/stats/drupal7-dev-participation-by-file-changes.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupal7-dev-participation-by-file-changes.txt
data/tagclouds/drupalfull-dev-participation-by-commits-no-committers.txt.tif: tagcloud-base data/stats/drupalfull-dev-participation-by-commits-no-committers.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupalfull-dev-participation-by-commits-no-committers.txt
data/tagclouds/drupalfull-dev-participation-by-commits.txt.tif: tagcloud-base data/stats/drupalfull-dev-participation-by-commits.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupalfull-dev-participation-by-commits.txt
data/tagclouds/drupalfull-dev-participation-by-file-changes-no-committers.txt.tif: tagcloud-base data/stats/drupalfull-dev-participation-by-file-changes-no-committers.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupalfull-dev-participation-by-file-changes-no-committers.txt
data/tagclouds/drupalfull-dev-participation-by-file-changes.txt.tif: tagcloud-base data/stats/drupalfull-dev-participation-by-file-changes.txt
	./TagCloud/application.linux/TagCloud destination=data/tagclouds file=data/stats/drupalfull-dev-participation-by-file-changes.txt
