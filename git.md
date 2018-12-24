### Create/Apply Patch
```
git format-patch $COMMIT_HASH --stdout > $OUTPUT.patch
git apply --stat $OUTPUT.patch`
git apply --check $OUTPUT.patch
git am --signoff < $OUTPUT.patch
# https://www.devroom.io/2009/10/26/how-to-create-and-apply-a-patch-with-git/
```


### Reset sub-directory

`git checkout HEAD -- $PATH`


### Migration from SVN
+ [GitLab tutorial](https://docs.gitlab.com/ee/user/project/import/svn.html#cut-over-migration-with-svn2git)
+ [Microsoft tutorial](https://docs.microsoft.com/en-us/azure/devops/articles/perform-migration-from-svn-to-git?view=vsts)
