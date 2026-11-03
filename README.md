# Водич за дружба со Жејко (TurtleBot 4, ROS 2 Jazzy)

Документ во LaTeX (`pdflatex`, кирилица со `T2A`). Главен фајл: `main.tex`.

## Структура
- `main.tex` – содржина на документот (глави и потсекции)
- `lab_notes.sty` – стил/шаблон (не се менува без договор)
- `logo.png`, `runba.png`, `figures/` – слики
- `arhiva/` – стари/неискористени фајлови (не влегуваат во компајлирањето)

## Правила за пишување
- Секоја глава се означува со `\glava{Наслов}{индекс на автор}`, а потсекциите со `\potglava{Наслов}{индекс}`.
- Авторите и нивните индекси се во `\author{...}` и во легендата по `\maketitle` во `main.tex`.
- Пишувај само во своите глави. Пред работа: `git pull`. После работа: `git add -A && git commit -m "опис" && git push`.
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
