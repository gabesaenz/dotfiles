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
    (pkgs.texliveBasic.withPackages (
      # texliveBasic provides "pdflatex"
      ps: with ps; [
        # required for org-latex-export-to-pdf
        wrapfig
        ulem
        capt-of
        metafont

        # required for org-beamer-export-to-pdf
        beamer
      ]
    ))
  ];
}
