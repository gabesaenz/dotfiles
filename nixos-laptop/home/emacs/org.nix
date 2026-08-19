{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ### HTML PDF export
    # required for org-pandoc-export-to-html5-pdf
    python314Packages.weasyprint
    ### Latex PDF export
    (texliveBasic.withPackages (
      # texliveBasic provides "pdflatex"
      ps: with ps; [
        # required for org-latex-export-to-pdf
        wrapfig
        ulem
        capt-of
        metafont

        # required for org-beamer-export-to-pdf
        beamer

        # required for Greek org-latex-export-to-pdf
        polyglossia
        # example org header:
        #+LANGUAGE: el-polyton
        #+LATEX_COMPILER: lualatex
        #+LATEX_HEADER: \newfontfamily\greekfont[Script=Greek]{Galatia SIL}
        #+LATEX_HEADER: \usepackage[german,AUTO]{polyglossia}
      ]
    ))
  ];
}
