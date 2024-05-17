#First open the secured backup.dmp on Dropbox
#  this will create the /Volumes/backup/gpg-keys
# GPG_ID can be an email or a fingerprint (gpg -K will show the fingerprints of secret keys you have)

ifndef GPG_ID
  $(error Please supply GPG_ID)
endif
#BACKUP_DIR:=/Volumes/backup/gpg-keys
# just copy with
# cp pgp-* /Volumes/backup/gpg-keys/

GPG_PUBLIC:=pgp-public-keys-${GPG_ID}.asc
GPG_PRIVATE:=pgp-private-keys-${GPG_ID}.asc
GPG_OWNERTRUST:=pgp-ownertrust-${GPG_ID}.txt
# GPG_REVOKE_CERT:=pgp-revoke-cert-${GPG_ID}.asc

TARGETS:=$(GPG_PUBLIC) $(GPG_PRIVATE) $(GPG_OWNERTRUST)

.PHONY: export
export: $(TARGETS)
	ls -l $^

all: $(TARGET)
	@echo "created $(TARGET)              # OR fullpath $(shell echo $$(pwd)/$(TARGET))"

$(GPG_PUBLIC) :
	gpg2 --armor --export --output $@ ${GPG_ID} && chmod 600 $@

$(GPG_PRIVATE) :
	gpg2 --armor --export-secret-keys --output $@ ${GPG_ID} && chmod 600 $@

$(GPG_OWNERTRUST) :
	gpg2 --export-ownertrust > $@ && chmod 600 $@

$(GPG_REVOKE_CERT) :
	gpg2 --gen-revoke ${GPG_ID} > $@ && chmod 600 $@

.PHONY: clean
clean:
	-rm $(TARGETS)
