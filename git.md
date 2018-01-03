### Create/Apply Patch
```
git format-patch $COMMIT_HASH --stdout > $OUTPUT.patch
git apply --stat $OUTPUT.patch`
git apply --check $OUTPUT.patch
git am --signoff < $OUTPUT.patch
# https://www.devroom.io/2009/10/26/how-to-create-and-apply-a-patch-with-git/
```
