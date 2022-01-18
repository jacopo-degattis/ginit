# Ginit

## Description

Create github repo remotely on github.
When you want to create a new repository on github, you don't need anymore to get on the github.com website.
You can easily launch this utility with the command:

```bash
$ ./gget.rb <repo_name>
```

> You can also specify some parameters

| Parameter | Description      | Options    |
| --------- | ---------------- | ---------- |
| -n        | Repo name        |            |
| -d        | Repo description |            |
| -v        | Repo visibility  | true/false |

~~And then do the usual stuff, like branch, add, commit and push !~~

> When you create a remote repository, this script will automatically initialize
> an empty local repository, an initial commit, REAMDE / LICENSE files and will set the remote
> repository that has just been created as target.

## Author

Jacopo De Gattis
