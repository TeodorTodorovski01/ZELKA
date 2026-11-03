# Водич за дружба со Жејко (TurtleBot 4, ROS 2 Jazzy)

Документ во LaTeX (`pdflatex`, кирилица со `T2A`). Главен фајл: `main.tex`.

## Преземање на проектот првпат (Fedora/Linux)
Ако сè уште ја немаш папката на проектот на компјутерот:

1. Отвори Terminal.
2. Инсталирај Git (ако веќе е инсталиран, ова може да се прескокне):
   ```bash
   sudo dnf install git
   ```
3. Оди во папката Downloads:
   ```bash
   cd ~/Downloads
   ```
4. Преземи го проектот од GitHub:
   ```bash
   git clone https://github.com/TeodorTodorovski01/ZELKA.git
   ```
5. Влези во папката на проектот:
   ```bash
   cd ZELKA
   ```
6. Продолжи со инсталацијата и градењето на PDF подолу.

Ако GitHub побара најава или дозвола, следи ги упатствата што ќе се појават во Terminal или во browser. За подоцнежно преземање на најновите измени, отвори Terminal во папката `ZELKA` и изврши `git pull`.

Ако сакаш само да ги прегледаш фајловите, можеш на GitHub да избереш **Code → Download ZIP** и да ја отпакуваш ZIP-датотеката. За да добиваш измени и да испраќаш свои, користи `git clone` како во чекорите погоре.

## Структура
- `main.tex` – содржина на документот (глави и потсекции)
- `lab_notes.sty` – стил/шаблон (не се менува без договор)
- `logo.png`, `runba.png`, `figures/` – слики
- `arhiva/` – стари/неискористени фајлови (не влегуваат во компајлирањето)

## Правила за пишување
- Секоја глава се означува со `\glava{Наслов}{индекс на автор}`, а потсекциите со `\potglava{Наслов}{индекс}`.
- Авторите и нивните индекси се во `\author{...}` и во легендата по `\maketitle` во `main.tex`.
- Пишувај само во своите глави. Пред работа изврши `git pull`. По измените, провери што ќе испратиш со `git status`, додај ги само изменетите фајлови со `git add име-на-фајл`, па изврши `git commit -m "опис"` и `git push`.
- Не додавај `.pdf` и помошни фајлови во репото (`.gitignore` ги игнорира).

## Компајлирање
- **Fedora, прво поставување:** инсталирај ги потребните LaTeX пакети (не целиот TeX Live):
  ```bash
  sudo dnf install \
    texlive-scheme-basic \
    texlive-tufte-latex \
    texlive-collection-latexrecommended \
    texlive-collection-langcyrillic \
    texlive-collection-fontsrecommended \
    texlive-extract \
    texlive-multibib \
    texlive-pstricks \
    texlive-sauerj \
    texlive-hardwrap \
    texlive-xifthen
  ```
- **Градење на PDF:** од папката на репото изврши `bash build.sh`. Скриптата го компајлира документот двапати и го зачувува во `build/main.pdf`.
- **VS Code:** инсталирај ја ексензијата *LaTeX Workshop* (препорачана); по инсталирањето на пакетите погоре може да градиш од VS Code.

Ако градењето запре со `File 'име.sty' not found`, недостасува LaTeX пакет. На Fedora најди кој пакет ја содржи датотеката со `dnf provides '*/име.sty'`, инсталирај го со `sudo dnf install име-на-пакет`, па повторно изврши `bash build.sh`.
