# Exam preparation

Prepare for the end is near. 🌋 🌋 :leaves:


![Ahhh shit here we go again!](img/when_the_pope_wants_to_take_back_the_holy_land.png "Ahhh shit here we go again")

## Dev guideline

### :penguin: Ubuntu

To install TeX simply run:

```bash
sudo apt install texlive texlive-lang-cyrillic texlive-latex-extra
# For VS Code integration
sudo apt install latexmk
```

Then in VSCode:

1. Install VS Code extension **LaTeX Workshop**
1. Go to **TeX** sidebar tab
1. Click **View LaTeX PDF**

ℹ️ *VS Code updates automatically on `.tex` save.*

### :apple: MacOS

To install TeX follow this [tutorial](https://tex.stackexchange.com/questions/462365/how-to-use-latex-on-vs-code) (*it covers VS Code integartion*).

### Conventions

Always put your topic in a folder named `xx` where `xx` are digits representing the topic number.
Always add your images in a subfolder of the topic folder named `img`, i.e. `xx/img`.
Always begin your topic title with `Тема xx\\ `.

### Creating a release

You need to have installed [jq](https://stedolan.github.io/jq/), [zip](https://linuxize.com/post/how-to-zip-files-and-directories-in-linux/) and `docker` as a prerequisite.

We have a script that uses docker latex to build all topic `tex` files, bundle them up, create a github release and upload the bundle as an asset.
You could run it with:

```bash
source .envrc # or just use direnv
GITHUB_API_TOKEN=api-token ./hack/release.sh tag=vx.x.x
```

### Links to useful resources

- [Something written by soft girls](https://drive.google.com/drive/folders/1RvNXix6UjzIm1BFbxI_se9q2q94zfLoS?usp=sharing)
- [Many more soft scripts](https://drive.google.com/drive/folders/1w91x7uKvEj_RJztHYV_y8pR-SC_RQqOf?usp=sharing)
- [Hand-written consultation materials](https://drive.google.com/drive/folders/1obA3PIWWbU4-pkRXqrTM9hrreb0hGrCJ?usp=sharing)
- [Table of consulations](https://docs.google.com/spreadsheets/d/1sbUp2tPAHLIrNS0jF4AVaVNHpwEvqoeAMP6iBrmKSYI/edit?fbclid=IwAR0KNEdX0bZ-u7CafCRClicDFjl4y_36uygYeCe5FKHsx-Fgw689PQqoZ1E#gid=0)
- [Mega drive](https://mega.nz/folder/HQUn3ARC#QhNhjfoBBu-u4m2tSfvs9w)
- [Databases reference book](https://people.inf.elte.hu/miiqaai/elektroModulatorDva.pdf)
- [Skelet-approved OS doc](https://skelet.ludost.net/OS/misc/DI_SI/)