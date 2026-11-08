%% pdarticle.cls -- article class for OmicVerse and PrimorDecode papers
%% https://github.com/omicverse/omicverse-latex-template
%%
%% Copyright (C) 2026 The OmicVerse developers
%%
%% This work may be distributed and/or modified under the conditions of the
%% LaTeX Project Public License, either version 1.3c of this license or (at
%% your option) any later version. The latest version of this license is in
%%   https://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX version
%% 2008 or later.
%%
%% This work has the LPPL maintenance status `maintained'.
%% The Current Maintainer of this work is The OmicVerse developers.
%%
%% Single-column manuscript layout by default (text block and type sizes
%% measured from a Cell Perspective); the twocolumn option gives a journal
%% layout. Default page design (design=rail): a narrow color rail down the
%% left edge of every page with the journal line set vertically in it, the
%% brand logo at the top left, a brand graphic in the top-right corner of
%% page 1, a small colored line with the article type above a large bold
%% title, a summary between two rules, and sentence-case colored headings.
%%
%% Usage:  \documentclass[brand=omicverse]{pdarticle}
%%         \documentclass[brand=primordecode]{pdarticle}
%% Options:
%%   brand=omicverse|primordecode   color preset, logo, and default names (default omicverse)
%%   primary=HEX      summary, journal name, links, author marks
%%   secondary=HEX    section headings, figure titles, journal section
%%   tab=HEX          the color tab on the page edge
%%   zh               Chinese typesetting (compile with XeLaTeX)
%%   lineno           line numbers (right margin) for review copies and preprints
%%   twocolumn        two-column journal layout (8.5 pt body, as in Cell)
%%   a4 (or paper=a4) A4 paper instead of US letter
%%   design=rail|masthead|panel|classic   page design (default rail; see README)
%% Engines: pdfLaTeX or XeLaTeX/LuaLaTeX for English; XeLaTeX for zh.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pdarticle}[2026/11/07 v0.3 PrimorDecode and OmicVerse article class]

\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=pd,prefix=pd@opt@}
\DeclareStringOption[omicverse]{brand}
\DeclareStringOption{primary}
\DeclareStringOption{secondary}
\DeclareStringOption{tab}
\DeclareBoolOption{zh}
\DeclareBoolOption{lineno}
\DeclareBoolOption{twocolumn}
\DeclareStringOption[rail]{design}
\DeclareStringOption[letter]{paper}
\DeclareVoidOption{a4}{\def\pd@opt@paper{a4}}
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*

\ifpd@opt@twocolumn
  \LoadClass[10pt,twocolumn]{article}
\else
  \LoadClass[10pt]{article}
\fi

%% ---------------------------------------------------------------- engine, fonts
\RequirePackage{iftex}
\ifpd@opt@zh
  \RequireXeTeX
\fi
\iftutex
  \RequirePackage{fontspec}
  \setmainfont{texgyreheros}[Extension=.otf,
    UprightFont=*-regular, BoldFont=*-bold,
    ItalicFont=*-italic, BoldItalicFont=*-bolditalic]
  \setsansfont{texgyreheros}[Extension=.otf,
    UprightFont=*-regular, BoldFont=*-bold,
    ItalicFont=*-italic, BoldItalicFont=*-bolditalic]
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{tgheros}
\fi
\renewcommand{\familydefault}{\sfdefault}

\ifpd@opt@zh
  \RequirePackage{xeCJK}
  % Simplified-Chinese faces first; on macOS, XeTeX loads the HK face of
  % PingFang.ttc even when "PingFang SC" is requested, so PingFang is last.
  \def\pd@cjk#1#2{\setCJKmainfont{#1}[BoldFont={#2}]\setCJKsansfont{#1}[BoldFont={#2}]}
  \IfFontExistsTF{Source Han Sans SC}{\pd@cjk{Source Han Sans SC}{Source Han Sans SC Bold}}{%
  \IfFontExistsTF{Noto Sans CJK SC}{\pd@cjk{Noto Sans CJK SC}{Noto Sans CJK SC Bold}}{%
  \IfFontExistsTF{Hiragino Sans GB}{\pd@cjk{Hiragino Sans GB W3}{Hiragino Sans GB W6}}{%
  \pd@cjk{PingFang SC}{PingFang SC Semibold}}}}
  \xeCJKsetup{PunctStyle=kaiming}
\fi

%% ---------------------------------------------------------------- colors and brand
\RequirePackage[table]{xcolor}
\definecolor{pdgray}{HTML}{9A9A9A}
\definecolor{pdrule}{HTML}{BDBDBD}

\def\pd@brand@ov{omicverse}
\edef\pd@brand{\pd@opt@brand}
\ifx\pd@brand\pd@brand@ov
  % OmicVerse: logo greens with a terracotta counterpoint
  \definecolor{pdtab}{HTML}{489332}
  \definecolor{pdprimary}{HTML}{36682B}
  \definecolor{pdsecondary}{HTML}{A8432A}
  \def\pd@logofile{logos/omicverse-logo}
  \def\pd@logosize{height=0.48in}
  \def\pd@org{OmicVerse}
\else
  % PrimorDecode: deep-space navy with accretion amber
  \definecolor{pdtab}{HTML}{0B1230}
  \definecolor{pdprimary}{HTML}{1C2B5A}
  \definecolor{pdsecondary}{HTML}{B85C17}
  \def\pd@logofile{logos/primordecode-wordmark}
  \def\pd@logosize{width=2.1in}
  \def\pd@org{PrimorDecode}
\fi
\ifx\pd@opt@primary\@empty\else\definecolor{pdprimary}{HTML}{\pd@opt@primary}\fi
\ifx\pd@opt@secondary\@empty\else\definecolor{pdsecondary}{HTML}{\pd@opt@secondary}\fi
\ifx\pd@opt@tab\@empty\else\definecolor{pdtab}{HTML}{\pd@opt@tab}\fi
\colorlet{pdtint}{pdprimary!7}
% Page design: classic (edge tab, after Cell), masthead, rail, or panel.
\edef\pd@design{\pd@opt@design}
\newcommand{\pd@ifdesign}[1]{\def\pd@tmp{#1}\ifx\pd@design\pd@tmp
  \expandafter\@firstoftwo\else\expandafter\@secondoftwo\fi}
\pd@ifdesign{classic}{}{\pd@ifdesign{masthead}{}{\pd@ifdesign{rail}{}{\pd@ifdesign{panel}{}{%
  \ClassWarning{pdarticle}{Unknown design `\pd@design', using classic}\def\pd@design{classic}}}}}
% Accent for figure titles and box titles: the secondary color in the
% classic design, the primary color in the others.
\pd@ifdesign{classic}{\colorlet{pdaccent}{pdsecondary}}{\colorlet{pdaccent}{pdprimary}}

%% ---------------------------------------------------------------- page geometry
\def\pd@paper@afour{a4}
\ifx\pd@opt@paper\pd@paper@afour
  \def\pd@paper{a4paper}
\else
  \def\pd@paper{letterpaper}
\fi
% Sizes: \pd@fs@<role> are {size}{leading} pairs used below.
\ifpd@opt@twocolumn
  % Two columns, sizes measured from a Cell Perspective (2026): body
  % 8.47/10.94 pt, summary 9.96/11.95 pt, title 19.93/20.9 pt, headings 8.47 pt.
  \def\pd@lm{0.8in}
  \RequirePackage[\pd@paper, top=1.38in, bottom=0.74in, left=0.8in, right=0.8in,
    columnsep=13pt, headheight=12pt, headsep=6pt, footskip=0.42in]{geometry}
  \def\pd@body{{8.5}{11}}\def\pd@sm{{7.5}{9.5}}\def\pd@fn{{7}{8.6}}
  \def\pd@sc{{6}{7.2}}\def\pd@ti{{5}{6}}\def\pd@lg{{10}{12}}\def\pd@Lg{{12}{14}}
  \def\pd@fs@kicker{{8}{10}}\def\pd@fs@type{{14}{16}}\def\pd@fs@title{{20}{21}}
  \def\pd@fs@author{{9}{11}}\def\pd@fs@affil{{8}{10}}\def\pd@fs@sumhead{{8.5}{10}}
  \def\pd@fs@sum{{10}{12}}\def\pd@fs@kw{{8}{10}}\def\pd@fs@sec{{8.5}{11}}
  \def\pd@fs@secN{{9.5}{11.5}}\def\pd@fs@bib{{7}{8.6}}\def\pd@fs@foot{{8}{10}}\def\pd@fs@lic{{7}{8.5}}
  \def\pd@sp@secB{11pt plus 2pt minus 1pt}\def\pd@sp@secA{4pt}
  \def\pd@sp@subB{8pt plus 2pt minus 1pt}\def\pd@sp@subA{2pt}
  \def\pd@sp@title{11pt}\def\pd@sp@sum{17pt}\def\pd@sp@end{22pt}
\else
  % One column for manuscripts and preprints, on the Cell text block: 0.8 in
  % side margins (Cell: 53-60 pt on a 603 pt page, a 490 pt measure), the same
  % top and bottom margins as the two-column layout, and a 6.9 in measure.
  % Type sizes and leading are the Cell values, as in the two-column layout
  % (body 8.5/11 pt), so a page reads at the same scale as a Cell page.
  \def\pd@lm{0.8in}
  \RequirePackage[\pd@paper, top=1.38in, bottom=0.74in, left=0.8in, right=0.8in,
    headheight=12pt, headsep=6pt, footskip=0.42in]{geometry}
  \def\pd@body{{8.5}{11}}\def\pd@sm{{7.5}{9.5}}\def\pd@fn{{7}{8.6}}
  \def\pd@sc{{6}{7.2}}\def\pd@ti{{5}{6}}\def\pd@lg{{10}{12}}\def\pd@Lg{{12}{14}}
  \def\pd@fs@kicker{{8}{10}}\def\pd@fs@type{{14}{16}}\def\pd@fs@title{{20}{21}}
  \def\pd@fs@author{{9}{11}}\def\pd@fs@affil{{8}{10}}\def\pd@fs@sumhead{{8.5}{10}}
  \def\pd@fs@sum{{10}{12}}\def\pd@fs@kw{{8}{10}}\def\pd@fs@sec{{8.5}{11}}
  \def\pd@fs@secN{{9.5}{11.5}}\def\pd@fs@bib{{7}{8.6}}\def\pd@fs@foot{{8}{10}}\def\pd@fs@lic{{7}{8.5}}
  \def\pd@sp@secB{12pt plus 2pt minus 1pt}\def\pd@sp@secA{4pt}
  \def\pd@sp@subB{8pt plus 2pt minus 1pt}\def\pd@sp@subA{2pt}
  \def\pd@sp@title{11pt}\def\pd@sp@sum{17pt}\def\pd@sp@end{14pt}
\fi
\def\pd@fs#1{\expandafter\fontsize#1\selectfont}
\setlength{\parindent}{1.1em}
\setlength{\parskip}{0pt}
\renewcommand\normalsize{\expandafter\@setfontsize\expandafter\normalsize\pd@body
  \abovedisplayskip 6\p@ \@plus2\p@ \@minus2\p@
  \abovedisplayshortskip \z@ \@plus2\p@
  \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
  \belowdisplayskip \abovedisplayskip \let\@listi\@listI}
\renewcommand\small{\expandafter\@setfontsize\expandafter\small\pd@sm}
\renewcommand\footnotesize{\expandafter\@setfontsize\expandafter\footnotesize\pd@fn}
\renewcommand\scriptsize{\expandafter\@setfontsize\expandafter\scriptsize\pd@sc}
\renewcommand\tiny{\expandafter\@setfontsize\expandafter\tiny\pd@ti}
\renewcommand\large{\expandafter\@setfontsize\expandafter\large\pd@lg}
\renewcommand\Large{\expandafter\@setfontsize\expandafter\Large\pd@Lg}
\normalsize
% Chinese needs a little more leading than Latin text (about 1.4 times the size).
\ifpd@opt@zh\linespread{1.08}\selectfont\fi
\raggedbottom
\setlength{\textfloatsep}{14pt plus 2pt minus 2pt}
\setlength{\dbltextfloatsep}{14pt plus 2pt minus 2pt}
\setlength{\floatsep}{10pt plus 2pt minus 2pt}
\setlength{\dblfloatsep}{10pt plus 2pt minus 2pt}
\emergencystretch=1.2em
\RequirePackage{microtype}
\RequirePackage{anyfontsize}
\RequirePackage{graphicx}
\RequirePackage{amsmath,amssymb}
\RequirePackage{booktabs}
\RequirePackage{tikz}
\usetikzlibrary{arrows.meta}

%% ---------------------------------------------------------------- metadata commands
\def\pd@journal{\pd@org}
\def\pd@section{}
\def\pd@type{Research Article}
\def\pd@info{\pd@journal, \today}
\def\pd@copyright{\the\year\ \pd@org}
\def\pd@license{}
\def\pd@affils{}
\def\pd@corresp{}
\def\pd@doi{}
\def\pd@summary{}
\def\pd@keywords{}
\newcommand{\journalname}[1]{\def\pd@journal{#1}}
\newcommand{\journalsection}[1]{\def\pd@section{#1}}
\newcommand{\articletype}[1]{\def\pd@type{#1}}
\newcommand{\journalinfo}[1]{\def\pd@info{#1}}
\newcommand{\copyrightholder}[1]{\def\pd@copyright{#1}}
\newcommand{\licenseline}[1]{\def\pd@license{#1}}
\newcommand{\brandlogo}[2][]{\def\pd@logofile{#2}\if\relax\detokenize{#1}\relax\else\def\pd@logosize{#1}\fi}
\newcommand{\affmark}[1]{\textsuperscript{\mdseries\color{pdprimary}#1}}
\newcommand{\affiliation}[2]{\g@addto@macro\pd@affils{\textsuperscript{#1}#2\par}}
\newcommand{\correspondence}[1]{\def\pd@corresp{%
  \ifpd@opt@zh *通讯作者：\else *Correspondence: \fi
  \href{mailto:#1}{\textcolor{pdprimary}{#1}}\par}}
\newcommand{\articledoi}[1]{\def\pd@doi{\href{https://doi.org/#1}{\textcolor{pdprimary}{https://doi.org/#1}}\par}}
\newcommand{\summary}[1]{\def\pd@summary{#1}}
\newcommand{\keywords}[1]{\def\pd@keywords{#1}}

\ifpd@opt@zh
  \def\pd@summaryname{摘要}
  \def\pd@keywordsname{关键词}
  \def\pd@boxname{专栏}
  \def\pd@summaryname@s{摘要}\def\pd@keywordsname@s{关键词}
\else
  \def\pd@summaryname{SUMMARY}
  \def\pd@keywordsname{KEYWORDS}
  \def\pd@boxname{Box}
  \def\pd@summaryname@s{Summary}\def\pd@keywordsname@s{Keywords}
\fi

%% ---------------------------------------------------------------- running heads (drawn on the page)
% As in Cell, the color tab and logo sit at the outer top corner and change
% sides from page to page: on the left of the first page and of every second
% page after it, on the right of the pages in between. The brand graphic (no
% lettering) takes the opposite top corner and is mirrored there. Graphics are
% TikZ code in inches, with the origin at the top-right corner of the page.
\newcount\pd@firstpage \pd@firstpage=1
\newif\ifpd@logoleft
% Pages with the parity of the first page carry the logo on the left.
\newcommand{\pd@setside}{\ifodd\numexpr\c@page-\pd@firstpage\relax
  \global\pd@logoleftfalse\else\global\pd@logolefttrue\fi}
\newcommand{\pd@logo}{\begingroup
  \edef\x{\endgroup\noexpand\includegraphics[\pd@logosize]{\pd@logofile}}\x}
% four-point star with concave sides: {x}{y}{size}{color}
\newcommand{\pd@star}[4]{\fill[#4] (#1,#2+#3) .. controls (#1+0.12*#3,#2+0.12*#3) ..
  (#1+#3,#2) .. controls (#1+0.12*#3,#2-0.12*#3) .. (#1,#2-#3) .. controls
  (#1-0.12*#3,#2-0.12*#3) .. (#1-#3,#2) .. controls (#1-0.12*#3,#2+0.12*#3) .. cycle;}

% PrimorDecode: hairline star chart. A ring of eleven circles that touch at
% one point, dense on the lit side and open on the far side (after the
% polarized image of M87*), crossed by a tilted orbit with an amber
% accretion trail, a companion body, four-point stars, and dust.
\newcommand{\pd@art@primordecode}{%
  \foreach \i in {0,...,10}{%
    \pgfmathsetmacro{\pd@r}{0.26+0.026*\i}%
    \pgfmathtruncatemacro{\pd@mix}{100-10*\i}%
    \pgfmathsetmacro{\pd@op}{1-0.045*\i}%
    \draw[line width=0.42pt, color=pdsecondary!\pd@mix!pdprimary, opacity=\pd@op]
      ({-0.851-0.766*\pd@r},{-0.967+0.643*\pd@r}) circle[radius=\pd@r];}%
  \begin{scope}[shift={(-1.12,-0.74)}, rotate=-18]
    \draw[line width=0.3pt, pdprimary!40, dash pattern=on 0.6pt off 2pt]
      (0,0) ellipse[x radius=2.3, y radius=0.46];
    \draw[line width=0.35pt, pdprimary!55, dash pattern=on 1.2pt off 1.6pt]
      (1.35,0) arc[start angle=0, end angle=180, x radius=1.35, y radius=0.22];
    \draw[line width=0.45pt, pdprimary]
      (1.35,0) arc[start angle=0, end angle=-180, x radius=1.35, y radius=0.22];
    \foreach \a in {-24,-30,...,-102}{%
      \pgfmathsetmacro{\pd@op}{0.08+0.92*sin(180*(-24-\a)/84)}%
      \draw[line width=1.5pt, pdsecondary, opacity=\pd@op, line cap=butt]
        ({1.35*cos(\a)},{0.22*sin(\a)})
        arc[start angle=\a, end angle=\a-6, x radius=1.35, y radius=0.22];}%
    \fill[pdprimary] ({1.35*cos(205)},{0.22*sin(205)}) circle[radius=0.03];
  \end{scope}
  \pd@star{-2.62}{-0.44}{0.075}{pdsecondary}
  \pd@star{-0.36}{-0.22}{0.05}{pdprimary}
  \pd@star{-1.98}{-1.02}{0.04}{pdprimary}
  \foreach \x/\y/\r in {-2.95/-0.78/0.011, -2.3/-0.2/0.009, -1.62/-0.18/0.012,
      -0.52/-1.06/0.010, -2.2/-0.66/0.008, -0.18/-0.6/0.009, -3.25/-0.3/0.008}{%
    \fill[pdprimary!65] (\x,\y) circle[radius=\r];}%
}

% OmicVerse: a double helix that runs off the right edge and, toward the
% left, fades out and dissolves into points, like cells in an embedding.
\newcommand{\pd@art@omicverse}{%
  \def\pd@A{0.2}\def\pd@L{0.95}\def\pd@Y{-0.68}%
  \foreach \s in {-3.25,-3.155,...,0.1}{%
    \pgfmathsetmacro{\pd@op}{min(1,max(0,(\s+3.3)/1.6))}%
    \draw[line width=0.8pt, pdtab!35, opacity=\pd@op]
      (\s,{\pd@Y+\pd@A*sin(360*\s/\pd@L)}) -- (\s,{\pd@Y-\pd@A*sin(360*\s/\pd@L)});}%
  \foreach \s in {-3.3,-3.15,...,0.1}{%
    \pgfmathsetmacro{\pd@op}{min(1,max(0.04,(\s+3.3)/1.6))}%
    \draw[line width=1.7pt, pdprimary, opacity=0.75*\pd@op, line cap=butt]
      plot[domain=\s:\s+0.15, samples=10, smooth] (\x,{\pd@Y-\pd@A*sin(360*\x/\pd@L)});
    \draw[line width=1.7pt, pdtab, opacity=\pd@op, line cap=butt]
      plot[domain=\s:\s+0.15, samples=10, smooth] (\x,{\pd@Y+\pd@A*sin(360*\x/\pd@L)});}%
  \pgfmathsetseed{20261107}%
  \foreach \i in {1,...,40}{%
    \pgfmathsetmacro{\pd@dx}{-2.55-1.6*rnd}%
    \pgfmathsetmacro{\pd@dy}{\pd@Y+(0.25+0.35*(-2.55-\pd@dx))*(rnd-0.5)*2}%
    \pgfmathsetmacro{\pd@dr}{0.009+0.022*rnd}%
    \pgfmathsetmacro{\pd@op}{max(0.15,0.9-0.45*(-2.55-\pd@dx))}%
    \ifodd\i \def\pd@c{pdtab}\else\def\pd@c{pdprimary!70}\fi
    \fill[\pd@c, opacity=\pd@op] (\pd@dx,\pd@dy) circle[radius=\pd@dr];}%
}

\ifx\pd@brand\pd@brand@ov
  \let\pd@art\pd@art@omicverse
\else
  \let\pd@art\pd@art@primordecode
\fi
% \brandgraphic{<TikZ code>} replaces the corner graphic; \brandgraphic{} removes it.
\newcommand{\brandgraphic}[1]{\def\pd@art{#1}}

\RequirePackage{eso-pic}
% XeTeX (xdvipdfmx): pgf adds the transparency resources to a page only if
% transparency was used before that page ships out. The corner graphic is
% drawn during shipout, so register transparency once at the start;
% otherwise page 1 would reference undefined ExtGState entries.
\ifxetex\AtBeginDocument{\setbox\z@\hbox{\pgfsetfillopacity{1}\pgfsetstrokeopacity{1}}}\fi
\newcommand{\pd@head@classic}{%
  \pd@setside
  \ifnum\c@page=\pd@firstpage
    \def\pd@tabt{0.46in}\def\pd@tabb{0.95in}\def\pd@logoy{0.705in}\def\pd@artdy{0in}\def\pd@artu{1in}%
  \else
    \def\pd@tabt{0.42in}\def\pd@tabb{0.90in}\def\pd@logoy{0.66in}\def\pd@artdy{0.25in}\def\pd@artu{0.62in}%
  \fi
  \begin{tikzpicture}[overlay, inner sep=0pt, outer sep=0pt]
  \ifpd@logoleft
    \fill[pdtab] (0,\paperheight-\pd@tabt) rectangle (\pd@lm-0.2in,\paperheight-\pd@tabb);
    \node[anchor=west] at (\pd@lm,\paperheight-\pd@logoy) {\pd@logo};
    \begin{scope}[shift={(\paperwidth,\paperheight-\pd@artdy)}, x=\pd@artu, y=\pd@artu]\pd@art\end{scope}
  \else
    \fill[pdtab] (\paperwidth,\paperheight-\pd@tabt) rectangle (\paperwidth-\pd@lm+0.2in,\paperheight-\pd@tabb);
    \node[anchor=east] at (\paperwidth-\pd@lm,\paperheight-\pd@logoy) {\pd@logo};
    \begin{scope}[shift={(0pt,\paperheight-\pd@artdy)}, x={(-\pd@artu,0pt)}, y=\pd@artu]\pd@art\end{scope}
  \fi
  \end{tikzpicture}}
\newcommand{\pd@logosmall}{\scalebox{0.7}{\pd@logo}}
% masthead: page 1 opens with a full-width tinted band that holds the logo
% and the brand graphic; later pages carry a small logo and a hairline rule.
\newcommand{\pd@head@masthead}{%
  \begin{tikzpicture}[overlay, inner sep=0pt, outer sep=0pt]
  \ifnum\c@page=\pd@firstpage
    \fill[pdtab!10] (0,\paperheight) rectangle (\paperwidth,\paperheight-1.1in);
    \begin{scope}
      \clip (0,\paperheight) rectangle (\paperwidth,\paperheight-1.1in);
      \begin{scope}[shift={(\paperwidth,\paperheight+0.12in)}, x=1in, y=1in]\pd@art\end{scope}
    \end{scope}
    \fill[pdprimary] (0,\paperheight-1.1in) rectangle (\paperwidth,\paperheight-1.125in);
    \node[anchor=west] at (\pd@lm,\paperheight-0.55in) {\pd@logo};
  \else
    \node[anchor=west] at (\pd@lm,\paperheight-0.6in) {\pd@logosmall};
    \node[anchor=east, text=pdgray] at (\paperwidth-\pd@lm,\paperheight-0.6in) {\pd@footfont\pd@info};
    \draw[pdprimary, line width=0.5pt] (\pd@lm,\paperheight-0.86in) -- (\paperwidth-\pd@lm,\paperheight-0.86in);
  \fi
  \end{tikzpicture}}
% rail: a narrow color rail down the left edge of every page, with the
% journal line and article type set vertically in it.
\newcommand{\pd@head@rail}{%
  \begin{tikzpicture}[overlay, inner sep=0pt, outer sep=0pt]
  \fill[pdtab] (0,0) rectangle (0.25in,\paperheight);
  \node[rotate=90, anchor=west, text=white] at (0.135in,0.95in)
    {\pd@fs\pd@fs@foot\bfseries\pd@info\quad{\mdseries\textperiodcentered\quad\pd@type}};
  \ifnum\c@page=\pd@firstpage
    \node[anchor=west] at (\pd@lm,\paperheight-0.62in) {\pd@logo};
    \begin{scope}[shift={(\paperwidth,\paperheight)}, x=0.85in, y=0.85in]\pd@art\end{scope}
  \else
    \node[anchor=west] at (\pd@lm,\paperheight-0.6in) {\pd@logosmall};
    \node[anchor=east, text=pdprimary] at (\paperwidth-\pd@lm,\paperheight-0.6in) {\pd@footfont\bfseries\thepage};
    \draw[pdrule, line width=0.4pt] (\pd@lm,\paperheight-0.9in) -- (\paperwidth-\pd@lm,\paperheight-0.9in);
  \fi
  \end{tikzpicture}}
% panel: on page 1 a full-width tinted panel holds the logo, brand graphic,
% title, authors and affiliations (its lower edge is found from a mark left
% by the title block, so the first run may draw it short); later pages carry
% a thin tinted strip with a small logo.
\newcommand{\pd@head@panel}{%
  \ifnum\c@page=\pd@firstpage
    \begin{tikzpicture}[overlay, remember picture, inner sep=0pt, outer sep=0pt]
    \pgfutil@ifundefined{pgf@sh@ns@pdpanelend}%
      {\fill[pdtab!9] (0,\paperheight) rectangle (\paperwidth,\paperheight-3.4in);}%
      {\fill[pdtab!9] (0,\paperheight) rectangle (\paperwidth,0 |- pdpanelend);}
    \begin{scope}[shift={(\paperwidth,\paperheight)}, x=1in, y=1in]\pd@art\end{scope}
    \node[anchor=west] at (\pd@lm,\paperheight-0.62in) {\pd@logo};
    \end{tikzpicture}%
  \else
    \begin{tikzpicture}[overlay, inner sep=0pt, outer sep=0pt]
    \fill[pdtab!9] (0,\paperheight) rectangle (\paperwidth,\paperheight-0.52in);
    \node[anchor=west] at (\pd@lm,\paperheight-0.26in) {\scalebox{0.55}{\pd@logo}};
    \node[anchor=east, text=pdgray] at (\paperwidth-\pd@lm,\paperheight-0.26in) {\pd@footfont\pd@info};
    \end{tikzpicture}%
  \fi}
\AddToShipoutPictureBG{\AtPageLowerLeft{%
  \pd@ifdesign{classic}{\pd@head@classic}{%
  \pd@ifdesign{masthead}{\pd@head@masthead}{%
  \pd@ifdesign{rail}{\pd@head@rail}{\pd@head@panel}}}}}

%% ---------------------------------------------------------------- footers
\RequirePackage{fancyhdr}
\newcommand{\pd@footfont}{\pd@fs\pd@fs@foot}
\newlength{\pd@numwidth}
\pd@ifdesign{classic}{%
\fancypagestyle{pdfirst}{\fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[L]{\parbox[t]{\textwidth}{\pd@footfont\raggedright
    \settowidth{\pd@numwidth}{\textbf{\thepage}\hspace{0.7em}}%
    \textbf{\thepage}\hspace{0.7em}\pd@info\ \textcopyright\ \pd@copyright
    \ifx\pd@license\@empty\else\par\hspace*{\pd@numwidth}%
      {\pd@fs\pd@fs@lic\pd@license}\fi}}}
% Later pages: the page number sits at the outer edge, on the same side as the
% logo, followed (or preceded) by the journal line and the article type.
\newcommand{\pd@footinfo}{\pd@info\hspace{0.6em}{\color{pdrule}|}\hspace{0.6em}{\color{pdgray}\pd@type}}
\fancypagestyle{pdmain}{\fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[L]{\pd@setside\ifpd@logoleft\pd@footfont\textbf{\thepage}\hspace{0.7em}\pd@footinfo\fi}%
  \fancyfoot[R]{\pd@setside\ifpd@logoleft\else\pd@footfont\pd@footinfo\hspace{0.7em}\textbf{\thepage}\fi}}
}{%
\pd@ifdesign{rail}{%
% rail: the journal line is on the rail; page 1 keeps the copyright and
% license at the foot, later pages put the page number in the header.
\fancypagestyle{pdfirst}{\fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[L]{\parbox[t]{0.8\textwidth}{\pd@footfont\raggedright\color{pdgray}\textcopyright\ \pd@copyright
    \ifx\pd@license\@empty\else\par{\pd@fs\pd@fs@lic\pd@license}\fi}}%
  \fancyfoot[R]{\pd@footfont\bfseries\color{pdprimary}\thepage}}
\fancypagestyle{pdmain}{\fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}}%
}{%
% masthead and panel: the page number stays at the right on every page.
\fancypagestyle{pdfirst}{\fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[L]{\parbox[t]{0.85\textwidth}{\pd@footfont\raggedright
    \pd@info\ \textcopyright\ \pd@copyright
    \ifx\pd@license\@empty\else\par{\pd@fs\pd@fs@lic\color{pdgray}\pd@license}\fi}}%
  \fancyfoot[R]{\pd@footfont\bfseries\color{pdprimary}\thepage}}
\fancypagestyle{pdmain}{\fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[L]{\pd@footfont\color{pdgray}\pd@type}%
  \fancyfoot[R]{\pd@footfont\bfseries\color{pdprimary}\thepage}}%
}}
\pagestyle{pdmain}

%% ---------------------------------------------------------------- title block
\newcommand{\pd@titleblock}{%
    \raggedright
    \ifx\pd@section\@empty\else
      {\pd@fs\pd@fs@kicker\bfseries\color{pdsecondary}\pd@upper{\pd@section}\par}\vspace{3pt}
    \fi
    {\pd@fs\pd@fs@type\bfseries\color{pdgray}\pd@type\par}
    \vspace{1pt}
    {\pd@fs\pd@fs@title\bfseries\@title\par}
    \vspace{\pd@sp@title}
    {\pd@fs\pd@fs@author\bfseries\@author\par}
    \vspace{1pt}
    {\pd@fs\pd@fs@affil\pd@affils\pd@corresp\pd@doi}
    \vspace{\pd@sp@sum}
    \ifx\pd@summary\@empty\else
      {\pd@fs\pd@fs@sumhead\bfseries\color{pdsecondary}\pd@summaryname\par}
      \vspace{6pt}
      {\pd@fs\pd@fs@sum\bfseries\color{pdprimary}%
        \leftskip=0pt\rightskip=0pt\parfillskip=0pt plus 1fil\relax
        \pd@summary\par}
    \fi
    \ifx\pd@keywords\@empty\else
      \vspace{8pt}
      {\pd@fs\pd@fs@kw\textbf{\color{pdsecondary}\pd@keywordsname}\quad\pd@keywords\par}
    \fi
    \vspace{\pd@sp@end}}
% Title blocks of the other designs: one small kicker line (article type and
% section) instead of the gray article type, a sentence-case summary label,
% and a regular-weight summary.
\newcommand{\pd@kicker}[1]{{\pd@fs\pd@fs@kicker\bfseries\color{#1}\pd@type
  \ifx\pd@section\@empty\else\hspace{0.45em}{\mdseries\textperiodcentered}\hspace{0.45em}\pd@section\fi\par}}
\newcommand{\pd@head@names}{%
  {\pd@fs\pd@fs@title\bfseries\@title\par}
  \vspace{\pd@sp@title}
  {\pd@fs\pd@fs@author\bfseries\@author\par}
  \vspace{1pt}
  {\pd@fs\pd@fs@affil\pd@affils\pd@corresp\pd@doi}}
\newcommand{\pd@sumtext}{\leftskip=0pt\rightskip=0pt\parfillskip=0pt plus 1fil\relax\pd@summary\par}
\newcommand{\pd@kwline}{\ifx\pd@keywords\@empty\else\vspace{7pt}%
  {\pd@fs\pd@fs@kw\textbf{\color{pdprimary}\pd@keywordsname@s}\quad\pd@keywords\par}\fi}
\newcommand{\pd@titleblock@masthead}{%
  \raggedright\pd@kicker{pdprimary}\vspace{5pt}\pd@head@names
  \vspace{\pd@sp@sum}
  \ifx\pd@summary\@empty\else
    \begin{tcolorbox}[enhanced, colback=pdtint, colframe=pdtint, boxrule=0pt, arc=0pt,
        borderline west={2.5pt}{0pt}{pdprimary}, left=12pt, right=12pt, top=9pt, bottom=10pt,
        before skip=0pt, after skip=0pt]
      {\pd@fs\pd@fs@sumhead\bfseries\color{pdprimary}\pd@summaryname@s\par}\vspace{4pt}
      {\pd@fs\pd@fs@sum\pd@sumtext}\pd@kwline
    \end{tcolorbox}
  \fi
  \vspace{\pd@sp@end}}
\newcommand{\pd@titleblock@rail}{%
  \raggedright\pd@kicker{pdsecondary}\vspace{5pt}\pd@head@names
  \vspace{\pd@sp@sum}
  \ifx\pd@summary\@empty\else
    {\color{pdprimary}\rule{\linewidth}{0.6pt}}\par\vspace{8pt}
    {\pd@fs\pd@fs@sumhead\bfseries\color{pdprimary}\pd@summaryname@s\par}\vspace{4pt}
    {\pd@fs\pd@fs@sum\color{pdprimary}\pd@sumtext}\pd@kwline
    \vspace{9pt}{\color{pdprimary}\rule{\linewidth}{0.6pt}}\par
  \fi
  \vspace{\pd@sp@end}}
\newcommand{\pd@panelmark}[1]{\tikz[remember picture, overlay]\coordinate (pdpanelend) at (0,#1);}
\newcommand{\pd@titleblock@panel}{%
  \raggedright\pd@kicker{pdprimary}\vspace{5pt}\pd@head@names
  \vspace{30pt}
  \ifx\pd@summary\@empty
    \noindent\pd@panelmark{1em}\par
  \else
    {\pd@fs\pd@fs@sumhead\bfseries\color{pdprimary}\noindent\pd@panelmark{2.1em}\pd@summaryname@s\par}\vspace{4pt}
    {\pd@fs\pd@fs@sum\pd@sumtext}\pd@kwline
  \fi
  \vspace{\pd@sp@end}}
\renewcommand{\maketitle}{%
  \global\pd@firstpage=\c@page
  \pd@ifdesign{classic}{}{\expandafter\let\expandafter\pd@titleblock\csname pd@titleblock@\pd@design\endcsname}%
  \ifpd@opt@twocolumn
    \twocolumn[{\pd@titleblock}]%
  \else
    \begingroup\pd@titleblock\par\endgroup
  \fi
  \thispagestyle{pdfirst}%
  % no top floats above the title block on page 1
  \suppressfloats[t]}

%% ---------------------------------------------------------------- headings
\RequirePackage{titlesec}
\setcounter{secnumdepth}{0}
\ifpd@opt@zh
  \let\pd@upper\@firstofone
\else
  \def\pd@upper#1{\MakeUppercase{#1}}
\fi
\pd@ifdesign{classic}{%
  \titleformat{\section}{\normalfont\pd@fs\pd@fs@sec\bfseries\color{pdsecondary}}{}{0pt}{\pd@upper}
  \titleformat{\subsection}{\normalfont\pd@fs\pd@fs@sec\bfseries\color{pdprimary}}{}{0pt}{}}{%
  % other designs: sentence-case headings in the primary color
  \pd@ifdesign{rail}{%
    \titleformat{\section}{\normalfont\pd@fs\pd@fs@secN\bfseries\color{pdprimary}}{}{0pt}%
      {\textcolor{pdsecondary}{\rule{0.5em}{0.5em}}\hspace{0.55em}}}{%
  \pd@ifdesign{panel}{%
    \titleformat{\section}{\normalfont\pd@fs\pd@fs@secN\bfseries\color{pdprimary}}{}{0pt}{}%
      [\vspace{1pt}{\color{pdrule}\titlerule[0.5pt]}]}{%
    \titleformat{\section}{\normalfont\pd@fs\pd@fs@secN\bfseries\color{pdprimary}}{}{0pt}{}}}%
  \titleformat{\subsection}{\normalfont\pd@fs\pd@fs@sec\bfseries}{}{0pt}{}}
\titlespacing*{\section}{0pt}{\pd@sp@secB}{\pd@sp@secA}
\titlespacing*{\subsection}{0pt}{\pd@sp@subB}{\pd@sp@subA}
\titleformat{\subsubsection}[runin]{\normalfont\bfseries\itshape}{}{0pt}{}[.]
\titlespacing*{\subsubsection}{0pt}{4pt plus 2pt}{0.5em}

%% ---------------------------------------------------------------- captions, boxes, tables
\RequirePackage{caption}
\captionsetup{font={small}, labelfont={bf,color=pdaccent}, labelsep=period,
  justification=justified, singlelinecheck=false, skip=6pt}
\ifpd@opt@zh
  \renewcommand{\figurename}{图}
  \renewcommand{\tablename}{表}
  \captionsetup{labelsep=quad}
\fi
% \pdcaption{Title}{Legend text}: bold colored title, legend below
\newcommand{\pdcaption}[2]{\caption[#1]{{\color{pdaccent}\bfseries #1}%
  \if\relax\detokenize{#2}\relax\else\par\smallskip\normalcolor\mdseries #2\fi}}
\newcommand{\tablehead}{\rowcolor{pdtint}}

\RequirePackage[most]{tcolorbox}
% \begin{pdbox}[breakable]{Title}: pass breakable for a box longer than a column
\newtcolorbox[auto counter]{pdbox}[2][]{enhanced,
  colback=pdtint, colframe=pdtint, boxrule=0pt, arc=0pt,
  left=8pt, right=8pt, top=7pt, bottom=8pt, fontupper=\small,
  before upper={{\color{pdaccent}\bfseries\pd@boxname~\thetcbcounter.\ #2\par}\smallskip}, #1}

%% ---------------------------------------------------------------- references, links
\RequirePackage[super,sort&compress,comma]{natbib}
\renewcommand{\bibfont}{\pd@fs\pd@fs@bib}
\setlength{\bibsep}{1.2pt}
\ifpd@opt@zh
  \renewcommand{\refname}{参考文献}
\else
  \renewcommand{\refname}{References}
\fi
\RequirePackage{xurl}
\RequirePackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=pdprimary, citecolor=pdprimary,
  urlcolor=pdprimary, pdfcreator={pdarticle.cls}}
% Figure, table and box mentions written as words, with panel letters:
% \figlink{fig:atlas}{Figure 1a} links ``Figure 1a'' to \label{fig:atlas}. A figure set
% without \caption (a legend in a side minipage, say) gets its target with
% \pdanchor{fig:atlas} inside the figure environment.
\newcommand{\figlink}[2]{\hyperref[#1]{#2}}
\newcommand{\pdanchor}[1]{\phantomsection\label{#1}}

%% ---------------------------------------------------------------- line numbers
% lineno, for review copies and preprints: light gray numbers in the right
% margin in one column (the rail or edge tab runs down the left edge), and
% outside each column in two columns.
\ifpd@opt@lineno
  \ifpd@opt@twocolumn\RequirePackage[switch]{lineno}\else\RequirePackage[right]{lineno}\fi
  \renewcommand{\linenumberfont}{\normalfont\scriptsize\color{pdgray}}
  \AtBeginDocument{\linenumbers}
\fi

\endinput
