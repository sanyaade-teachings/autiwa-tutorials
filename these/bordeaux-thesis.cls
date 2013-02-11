%########################################################################
% 
% Filename : bordeaux-thesis.cls
% Author   : Vincent Feuvrier
% Contact  : vincent.feuvrier@normalesup.org
%
% Simple to use LaTeX class for writing thesis in mathematics at 
% Paris-Sud university.
%
% See included manual files for usage.
%
%########################################################################

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bordeaux-thesis}[2008/10/10 Custom class for writing thesis in astrophysics at Bordeaux University]

%########################################################################
% Options
%########################################################################


\RequirePackage{ifthen}
\RequirePackage{keyval}


\def\@phd@language{french}
\def\@phd@babel@language{frenchb}
\def\@phd@select@language{%
  \expandafter\expandafter\expandafter\selectlanguage\expandafter\expandafter\expandafter{\@phd@babel@language}%
}

\define@key{bordeaux-thesis}{mainlanguage}{%
  \gdef\@phd@language{#1}%
  \ifthenelse{\equal{#1}{french}}{%
    \gdef\@phd@babel@language{frenchb}%
  }{%
    \gdef\@phd@babel@language{#1}%
  }%  
}

\def\@phd@languages{english,frenchb}
\define@key{bordeaux-thesis}{morelanguage}{%
  \edef\@phd@languages{#1,\@phd@languages}%
}

\newif\if@phd@parttoc
\@phd@parttocfalse
\define@key{bordeaux-thesis}{parttoc}[]{\@phd@parttoctrue}

\newif\if@phd@logos
\@phd@logosfalse
\define@key{bordeaux-thesis}{logos}[]{\@phd@logostrue}

\newif\if@phd@lists
\@phd@listsfalse
\define@key{bordeaux-thesis}{lists}[]{\@phd@liststrue}

\let\@keyval@options@list\@empty
\def\@extract@key#1=#2\@extract@key{#1}

\def\@ProcessKeyvalOptions#1{%
  \let\@tempa\@empty
  \let\@tempb\@empty
  \@for\CurrentOption:=\@keyval@options@list\do{%
    \expandafter\expandafter\expandafter\def\expandafter\expandafter\expandafter\@key\expandafter\expandafter\expandafter{%
      \expandafter\@extract@key\CurrentOption=\@extract@key%
    }%
    \@ifundefined{KV@#1@\@key}{\edef\@tempa{\@tempa,\CurrentOption,}}{\edef\@tempb{\@tempb,\CurrentOption,}}
  }%
  \@for\CurrentOption:=\@tempa\do{%
    \ifx\CurrentOption\@empty%
    \else%
      \PassOptionsToClass{\CurrentOption}{report}%
    \fi%
  }%
  \edef\@tempb{%
    \noexpand\setkeys{#1}{\@tempb}%
  }%
  \@tempb%
  \AtEndOfPackage{%
    \let\@unprocessedoptions\relax%
  }%
}

\DeclareOption*{%
  \expandafter\expandafter\expandafter\def\expandafter\expandafter\expandafter\@keyval@options@list\expandafter\expandafter\expandafter{%
    \expandafter\@keyval@options@list\expandafter,\CurrentOption%
  }%
}

\ProcessOptions\relax
\@ProcessKeyvalOptions{bordeaux-thesis}%

%########################################################################
% Base class and packages
%########################################################################

\LoadClass[a4paper,twoside,12pt]{report}

\RequirePackage[Lenny]{fncychap} % beaux chapitres ; Sonny, Lenny, Glenn, Conny, Rejne, Bjarne


%Language
\RequirePackage[\@phd@languages,\@phd@babel@language]{babel}
\RequirePackage{textcomp}
\RequirePackage[autolanguage]{numprint}

%Page setup
\RequirePackage[hmargin={3cm,2.3cm},vmargin={3cm,2cm}]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}

%Part table of contents
\def\@finalize@parttoc{%
  \if@phd@doneparttoc%
  \else%
    \doparttoc%
    \faketableofcontents%
  \fi%
}
\if@phd@parttoc%
  \AtEndDocument{\@finalize@parttoc}
  \RequirePackage[french]{minitoc}
  \setcounter{tocdepth}{2}
  \mtcsetdepth{parttoc}{3}
  \newif\if@phd@doneparttoc
  \@phd@doneparttocfalse
  \let\@old@tableofcontents=\tableofcontents
  \def\tableofcontents{%
    \@phd@doneparttoctrue%
    \dominitoc%
    \@old@tableofcontents%
  }
\fi

%Logos
\if@phd@logos
\RequirePackage{graphicx}
\RequirePackage{ifpdf}
\fi

%Math
\RequirePackage{amsmath,amssymb,amsfonts}

%Misc
\RequirePackage{tabularx}

%########################################################################
% Lists and parts setup
%########################################################################

\newlength\defparindent
\newlength\defitemsep
\newlength\itemizesep
\newlength\itemizeparskip

\setlength\defparindent{20pt}
\setlength\parskip{0.5\baselineskip}
\setlength\itemizesep{0.3333\baselineskip}
\setlength\defitemsep\itemizesep
\setlength\itemizeparskip{0.25\baselineskip}

\AtBeginDocument{%
  \if@phd@lists%
    \setlength\parindent\defparindent%
    \let\olditemize=\itemize%
    \renewenvironment{itemize}{%
      \olditemize%
      \addvspace{\itemizesep}%
      \setlength\itemindent{9pt}%
      \setlength\itemsep\defitemsep%
      \addtolength\itemsep{-\itemizeparskip}%
      \setlength\parskip\itemizeparskip%
      \setlength\parindent\defparindent%
    }{%
      \endlist%
      \addvspace{\itemizesep}%
    }%
    \let\oldenumerate=\enumerate%
    \renewenvironment{enumerate}{%
      \olditemize%
      \addvspace{\itemizesep}%
      \setlength\itemindent{8pt}%
      \setlength\itemsep\defitemsep%
      \addtolength\itemsep{-\itemizeparskip}%
      \setlength\parskip\itemizeparskip%
      \setlength\parindent\defparindent%
    }{%
      \endlist%
      \addvspace{\itemizesep}%
    }%
    \renewcommand\labelitemi{$\diamond$}%
    \renewcommand\labelitemii{$\star$}%
    \renewcommand\labelitemiii{-}%
  \fi%
  \let\@phd@old@part=\@part%
  \def\@part[#1]#2{%
    \newpage%
    \@phd@old@part[#1]{#2}%
    \if@phd@parttoc\vfill\minitoc\fi%
    \vfill%
    \newpage%
  }%
  \let\@phd@old@chapter=\@chapter%
  \def\@chapter[#1]#2{%
    \newpage%
    \@phd@old@chapter[#1]{#2}%
    \if@phd@parttoc\vfill\minitoc\fi%
    \vfill%
    \newpage%
  }%
%  \renewcommand\sectionmark[1]{\markright{#1}\gdef\@phd@current@section{#1}}%
%  \renewcommand\subsectionmark[1]{\markboth{\thesubsection\ -\ \emph{#1}}{\@phd@current@section}}%
}

%########################################################################
% Page setup
%########################################################################

\tolerance=10000
\hbadness=10000

\pagestyle{fancy}
\fancyhf{}
\fancyhead[RO,LE]{\footnotesize\textbf{\thepage}}
\fancyhead[RE]{\footnotesize\scshape\rightmark}
\fancyhead[LO]{\footnotesize\leftmark}

\setlength\headheight{16pt}
\setlength\headsep{\baselineskip}

%########################################################################
% Title page
%########################################################################

\renewcommand\title[2][\@phd@language]{%
  \expandafter\gdef\csname @title@#1\endcsname{#2}%
}

\newcommand\keywords[2][\@phd@language]{%
  \expandafter\gdef\csname @keywords@#1\endcsname{#2}%
}

\newcommand\ordernumber[1]{%
  \gdef\@ordernumber{#1}%
}

\newcounter{@member}
\newcounter{@referee}

\newcommand\addcommissionmember[4][]{%
  \stepcounter{@member}%
  \ifthenelse{\equal{#1}{}}{%
    \expandafter\def\csname @member@\the@member\endcsname{#2&#3&\textsc{#4}&}%
  }{%
    \expandafter\def\csname @member@\the@member\endcsname{#2&#3&\textsc{#4}&(#1)}%
  }%
}

\newcommand\addreferee[3]{%
  \stepcounter{@referee}%
  \expandafter\def\csname @referee@\the@referee\endcsname{#1&#2&#3&}%
}

\newcommand\includelogo[2][]{%
  \ifpdf%
    \includegraphics[#1]{logos/#2.pdf}%
  \else%
    \includegraphics[#1]{logos/#2.eps}%
  \fi%
}

\renewcommand\maketitle{%
  \selectlanguage{frenchb}%
  \setcounter{page}{1}%
  \thispagestyle{empty}%
  \Large%
  \if@phd@logos%
    \noindent%
    \includelogo[height=2cm]{logo_univ_de_bdx}%
    \hfill%
    \includelogo[height=2cm]{logo-cnrs}%
    {\normalsize\\}%
  \else%
    \begin{center}%
      \begin{tabular}{|c|}%
        \hline\\[-1.5\medskipamount]%
        UNIVERSIT\'E BORDEAUX 1\\%
        ÉCOLE DOCTORALE DES SCIENCES PHYSIQUES ET DE L'ING\'{E}NIEUR\\[\smallskipamount]%
        \hline%
      \end{tabular}%
    \end{center}%
  \fi%
  {\normalsize\No d'ordre : \@ordernumber}%
  \vfill
  \begin{center}%
    \textbf{\Huge TH\`{E}SE}%
    \\[\bigskipamount]%
    \large%
    Pr\'{e}sent\'{e}e par %
    \\[\medskipamount]%
    \textbf{\@author}%
    \\[4\bigskipamount]%
    pour obtenir le grade de %
    \\[1.5\bigskipamount]%
    \begin{minipage}{0.65\textwidth}%
      \large%
      \centering%
      \textsc{\bfseries Docteur en Sciences de L'Universit\'{e} Bordeaux 1}%
    \end{minipage}%
    \\[1.5\bigskipamount]%
    \large%
    Sp\'{e}cialit\'{e} : Astrophysique, Plasmas, Corpuscules%
    \bigskip
    \hrule%
    \bigskip%
    \begin{minipage}{0.9\textwidth}%
      \LARGE%
      \bfseries%
      \centering%
      \@phd@select@language%
      \csname @title@\@phd@language\endcsname%
      \selectlanguage{frenchb}%
    \end{minipage}%
    \bigskip%
    \hrule
  \end{center}%
  \vfill%
  \ifnum\the@member=0\relax%
    \ClassWarning{bordeaux-thesis}{No commission member have been given}{You can provide members using the command \string\addcommissionmember.}%
  \else%
    \normalsize%
    \@ifundefined{c@@tempa}{\newcounter{@tempa}}{}%
    \setcounter{@tempa}{0}%
    \begin{tabular}{>{\hspace{0.08\textwidth}}cr@{ }ll}%
      \multicolumn{4}{l}{\large Soutenue le \@date{} devant la Commission d'examen:}\\[\medskipamount]%
      \whiledo{\value{@tempa}<\value{@member}}{%
        \stepcounter{@tempa}%
        \csname @member@\the@tempa\endcsname%
        \ifnum\value{@tempa}<\value{@member}\relax%
          \\%
        \fi%
      }%
      \ifnum\value{@referee}>0\relax
        \setcounter{@tempa}{0}%
        \\[\bigskipamount]%
        \multicolumn{4}{l}{\large Rapporteurs:}\\[\medskipamount]%
        \whiledo{\value{@tempa}<\value{@referee}}{%
          \stepcounter{@tempa}%
          \csname @referee@\the@tempa\endcsname\\%
        }%
      \fi
    \end{tabular}
  \fi%
  \newpage%
  \null%
  \vfill%
  \thispagestyle{empty}%
  \footnotesize%
  \def\@temp{
    \begin{minipage}[b]{.75\textwidth}
    \noindent Th\`{e}se pr\'{e}par\'{e}e au\\%
      \textbf{Laboratoire d'Astrophysique de Bordeaux}\\%
      Observatoire Aquitain des Sciences de l'Univers (OASU, UMR 5804-LAB)\\%
      2, rue de l'observatoire\\%
      \numprint{33271} Floirac CEDEX%
    \end{minipage}%
  }%
  \if@phd@logos%
    \noindent%
    \includelogo[width=0.2\textwidth]{logo-lab}\hfill\@temp%
  \else%
    \@temp%
  \fi%
  \hfill%
%  \@ifundefined{@phd@templena}{\newlength\@phd@templena}{}%
%  \settoheight\@phd@templena{\@temp}%
%  \addtolength\@phd@templena{-0.75\bigskipamount}%
%  \raisebox{\@phd@templena}[0pt][0pt]{\@temp}%
  \normalsize%
  \newpage%
  \@phd@select@language%
}

%########################################################################
% Multilingual abstracts
%########################################################################

\def\keywordsname{Keywords}
\def\summaryname{Summary}

\addto\captionsfrench{%
  \renewcommand\keywordsname{Mots-clefs}%
  \renewcommand\summaryname{Sommaire}%
}

\addto\captionsenglish{%
  \renewcommand\keywordsname{Keywords}%
  \renewcommand\summaryname{Summary}%
}

\addto\captionsgerman{%
  \renewcommand\keywordsname{Schlagworte}%
  \renewcommand\summaryname{Inhaltsverzeichnis}%
}

\addto\captionsitalian{%
  \renewcommand\keywordsname{Keywords}%
  \renewcommand\summaryname{Indice}%
}

\renewenvironment{abstract}[1][\@phd@language]{%
  \edef\@phd@current@abstract@language{#1}%
  \expandafter\expandafter\expandafter\selectlanguage\expandafter\expandafter\expandafter{#1}%
  \small%
  \setlength\parskip{0pt}%
  \parindent=\defparindent%
  \begin{center}%
    \ifthenelse{\equal{#1}{\@phd@language}}{}{%
      \textsc{%
        \normalsize%
        \@ifundefined{@title@#1}{%
          \ClassError{bordeaux-thesis}{No title given for language "#1"}{Title for language "#1" is mandatory for this class. You should provide one using the title command.}%
        }{%
          \csname @title@#1\endcsname%
          \nopagebreak[4]%
          \\[1ex]%
        }%
      }%
    }%
    {\bfseries\abstractname}%
  \end{center}%
  \unskip%
  \medskip%
  \nopagebreak[4]%
  \par%
}{%
  \nopagebreak[4]%
  \\[\smallskipamount]%
  \nopagebreak[4]%
  \textbf{\uppercase{\keywordsname}} : %
  \@ifundefined{@keywords@\@phd@current@abstract@language}{%
    \ClassError{bordeaux-thesis}{No keywords given for language "\@phd@current@abstract@language"}{Keywords for language "\@phd@current@abstract@language" are mandatory for this class. You should provide them using the keywords command.}%
  }{%
    \csname @keywords@\@phd@current@abstract@language\endcsname.%
  }%
  \par%
  \@phd@select@language%
}

%########################################################################
% Initialization
%########################################################################

\def\@title@french{???\ClassError{bordeaux-thesis}{No French title given}{French title is mandatory for this class. You should provide one using the \protect\title command.}}
\def\@title@english{???\ClassError{bordeaux-thesis}{No English thesis title given}{English title is mandatory for this class. You should provide one using the \protect\title command.}}
\def\@keywords@french{???\ClassError{bordeaux-thesis}{No French keywords given}{English keywords are mandatory for this class. You should provide them using the \protect\keywords command.}}
\def\@keywords@english{???\ClassError{bordeaux-thesis}{No English keywords given}{English keywords are mandatory for this class. You should provide them using the \protect\keywords command.}}
\def\@author{???\ClassError{bordeaux-thesis}{No author given}{The author is mandatory for this class. You should provide one using the \protect\author command.}}
\def\@date{??/??/??\ClassError{bordeaux-thesis}{No defense date given}{The defense date is mandatory for this class. You should provide one using the \protect\date command.}}
\def\@ordernumber{\ClassWarning{bordeaux-thesis}{No order number given}{The order number was not specified. You should provide one using the \protect\order command.}}
