#First open the secured backup.dmp on Dropbox
#  this will create the /Volumes/backup/gpg-keys
BACKUP_DIR:=/Volumes/backup/gpg-keys
BACKUP_PUBLIC:=$(BACKUP_DIR)/pgp-public-keys.asc
BACKUP_PRIVATE:=$(BACKUP_DIR)/pgp-private-keys.asc
BACKUP_OWNERTRUST:=$(BACKUP_DIR)/pgp-ownertrust.asc
TARGET:=gpg-keys.tar.gz

all: $(TARGET)
	@echo "created $(TARGET)              # OR fullpath $(shell echo $$(pwd)/$(TARGET))"

$(BACKUP_PUBLIC) $(BACKUP_PRIVATE) $(BACKUP_OWNERTRUST) :
	gpg2 --armor --export > $(BACKUP_PUBLIC) && chmod 600 $(BACKUP_PUBLIC)
	gpg2 --armor --export-secret-keys > $(BACKUP_PRIVATE) && chmod 600 $(BACKUP_PRIVATE)
	gpg2 --export-ownertrust > $(BACKUP_OWNERTRUST) && chmod 600 $(BACKUP_OWNERTRUST)

$(TARGET): $(BACKUP_PUBLIC) $(BACKUP_PRIVATE) $(BACKUP_OWNERTRUST)
	tar -cvzf $@ $^

.PHONY: clean
clean:
	-rm $(TARGET)
