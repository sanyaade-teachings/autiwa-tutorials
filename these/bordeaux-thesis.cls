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

\newif\if@phd@chaptertoc
\@phd@chaptertocfalse
\define@key{bordeaux-thesis}{chaptertoc}[]{\@phd@chaptertoctrue}

\newif\if@phd@logos
\@phd@logosfalse
\define@key{bordeaux-thesis}{logos}[]{\@phd@logostrue}

\newif\if@phd@lists
\@phd@listsfalse
\define@key{bordeaux-thesis}{lists}[]{\@phd@liststrue}

\newif\if@phd@print
\@phd@printfalse
\define@key{bordeaux-thesis}{print}[]{\@phd@printtrue}

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

\LoadClass[a4paper,twoside, openright,12pt]{report}

\RequirePackage[Lenny]{fncychap} % beaux chapitres ; Sonny, Lenny, Glenn, Conny, Rejne, Bjarne


%Language
\RequirePackage[\@phd@languages,\@phd@babel@language]{babel}
\RequirePackage{textcomp}
\RequirePackage[autolanguage]{numprint}

%Page setup
\RequirePackage[hmargin={3cm,2.3cm},vmargin={3cm,2cm}]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}

\RequirePackage[frenchb]{babel}
\FrenchFootnotes % pour les notes de bas de page
\AddThinSpaceBeforeFootnotes % pour les puristes (donc tout le monde!) qui veulent une espace fine entre le mot et l'appel de note

\RequirePackage[autolanguage]{numprint}
\RequirePackage[font=small,format=plain,labelsep=endash]{caption}

%meta paquet qui regroupe des environnements, des commandes persos et cie. Permet de les ajouter plus simplement dans mon paquet pour du latex normal, des beamers ou des posters. Ainsi les commandes ne sont qu'à un seul endroit.
\RequirePackage{autiwa-macros}

\RequirePackage[french]{varioref}
\vrefwarning % To transform errors in warning, in particular when a vref is between two pages. 

\renewcommand{\refeq}[1]{(\vref*{#1})}

% If at the beginning of a sentence, use \reffig*{theref}, else, use \reffig{theref}
\newcommand*\reffig@nostar[1]{[\figurename~\vref{#1}]}
\newcommand*\reffig@star[1]{Figure~\vref{#1}}
\newcommand{\reffig}{\@ifstar{\reffig@star}{\reffig@nostar}}

\newcommand{\reftab}[1]{[\tablename~\vref{#1}]}
\newcommand{\refsec}[1]{[\S~\vref{#1}]}


%%% mise en page %%%
\RequirePackage{multicol}%permet de mettre du texte sur plusieurs colonnes sans changer de pages (très pratique pour deux colonnes, vu que par défaut, il change de page
\RequirePackage{natbib}%améliore la bibliographie, surtout pour citer les publications scientifiques.

\RequirePackage{frbib}%pour mettre la bibliographie en français


\RequirePackage{aas_macros}% contient les macros pour la déifnition des noms de journaux des publications scientifiques utilses pour les enterées bibtex de ADS.
\RequirePackage{tocbibind}%pour que la bibliographie  et l'index apparaissent dans la table des matières. l'option permet de ne pas afficher la table des matières. (notlof, notlot pour table des figures et ou des tableaux)
\RequirePackage{xspace}%Permet à babel d'utiliser la macro xspace  partout où c'est nécessaire. (Voir la doc de babel pour de plus amples explications.)
\RequirePackage{acronym}%pour gérer les acronymes. Description du paquet dans mon pdf, ou dans la description du paquet acronym.sty


\RequirePackage[pdftex]{hyperref}%l'option pagebackref permet d'afficher les pages dans lesquelles sont citées les références (en gros, la position des labels je pense)
\hypersetup{
  colorlinks=true, %colorise les liens
  breaklinks=true, %permet le retour à la ligne dans les liens trop longs
  urlcolor= blue,  %couleur des hyperliens
  linkcolor= refcolor, %couleur des liens internes
  plainpages=false,  %pour palier à "Bookmark problems can occur when you have duplicate page numbers, for example, if you have a page i and a page 1."
  citecolor=refcolor % pour définir la couleur des liens de bibliographie
}

%%% graphiques et images %%%

\RequirePackage{afterpage} % permet de placer des images plus intelligemment
\RequirePackage{graphics}
\RequirePackage[pdftex]{graphicx}
\RequirePackage[justification=centerfirst]{subfig}%pour pouvoir mettre plusieurs figures dans le même environnement de figure, avec plusieurs caption

%%% divers %%%
\pdfcompresslevel=9
\RequirePackage{makeidx} %pour faire un index. J'ai mis la commande d'indexation dans \gras{} d'ailleurs. Ensuite, on crée l'index via la commande \makeindex et on l'affiche via la commande \printindex. Pour indexer un mot, il faut écrire \index{mot}. Attention à respecter la casse pour le même mot.

%Part table of contents
\def\@finalize@chaptertoc{%
  \if@phd@donechaptertoc%
  \else%
    \dominitoc%
    \faketableofcontents%
  \fi%
}
\if@phd@chaptertoc%
  \AtEndDocument{\@finalize@chaptertoc}
  \RequirePackage[french, nohints]{minitoc}
  \setcounter{tocdepth}{2}
  \mtcsetdepth{minitoc}{3}
  \newif\if@phd@donechaptertoc
  \@phd@donechaptertocfalse
  \let\@old@tableofcontents=\tableofcontents
  \def\tableofcontents{%
    \@phd@donechaptertoctrue%
    \dominitoc%
    \@old@tableofcontents%
  }
\fi

%Logos
\RequirePackage{ifpdf}

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
    \@phd@old@part[#1]{#2}%
    \if@phd@chaptertoc\vfill\minitoc\fi%
    \vfill%
    \newpage%
  }%
  \let\@phd@old@chapter=\@chapter%
  \def\@chapter[#1]#2{%
    \@phd@old@chapter[#1]{#2}%
    \if@phd@chaptertoc\vfill\minitoc\fi%
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

\renewcommand\theequation{\thechapter.\arabic{equation}}
\@addtoreset{equation}{chapter}

% Definition of a command allowing us to make a completely blanck page before a chapter if necessary, to ensure that the chapter begin on an odd page (i.e, the left page on a double page)
 
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
\hbox{} 
\thispagestyle{empty}
\newpage
\if@twocolumn\hbox{}\newpage\fi\fi\fi} 

%########################################################################
% Title page macros
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

\newcommand{\submityear}[1]{%
  \gdef\@submityear{#1}%
}

\newcounter{@member}
\newcounter{@referee}

\newcommand\addcommissionmember[4]{%
  \stepcounter{@member}%
  \expandafter\def\csname @member@\the@member\endcsname{#2 \textsc{#3}&#4\dotfill & {#1}}%
}

\newcommand\addreferee[4][Rapporteur]{%
  \stepcounter{@referee}%
  \ifnum\value{@referee}=1\relax
\expandafter\def\csname @referee@\the@referee\endcsname{& #2 \textsc{#3} \dotfill & Rapporteurs}%
\else
\expandafter\def\csname @referee@\the@referee\endcsname{& #2 \textsc{#3}\dotfill &}%
\fi
  \addcommissionmember{#1}{#2}{#3}{#4}
}

\newcommand\includelogo[2][]{%
  \ifpdf%
    \includegraphics[#1]{logos/#2.pdf}%
  \else%
    \includegraphics[#1]{logos/#2.eps}%
  \fi%
}


%########################################################################
% Title Page
%########################################################################

\renewcommand\maketitle{
  \selectlanguage{frenchb}
  \setcounter{page}{1}
  \thispagestyle{empty}
  \Large
  \if@phd@logos
    \noindent
    \includelogo[height=2cm]{logo-bx1}
    \hfill
    \includelogo[height=2cm]{logo-cnrs}
    {\normalsize\\}
  \else
    \begin{center}
      \begin{tabular}{|c|}
        \hline\\[-1.5\medskipamount]
        UNIVERSIT\'E BORDEAUX 1\\
        ÉCOLE DOCTORALE DES SCIENCES PHYSIQUES ET DE L'ING\'{E}NIEUR\\[\smallskipamount]
        \hline
      \end{tabular}
    \end{center}
  \fi
  {\normalsize\No d'ordre : \@ordernumber}
  
  \begin{center}
    \textbf{\Huge TH\`{E}SE}
    \\[\bigskipamount]
    \large
    Pr\'{e}sent\'{e}e par 
    \\[\medskipamount]
    \textbf{\@author}
    \\[\medskipamount]
    pour obtenir le grade de 
    \\[1.5\bigskipamount]
    \begin{minipage}{0.65\textwidth}
      \large
      \centering
      \textsc{\bfseries Docteur en Sciences de L'Universit\'{e} Bordeaux 1}
    \end{minipage}
    \\[1.5\bigskipamount]
    \large
    Sp\'{e}cialit\'{e} : Astrophysique, Plasmas, Corpuscules
    \vfill
    \rule{0.9\linewidth}{0.5mm}
    \\[\bigskipamount]
    \begin{minipage}{0.9\textwidth}
      \LARGE
      \bfseries
      \centering
      \@phd@select@language
      \csname @title@\@phd@language\endcsname
      \selectlanguage{frenchb}
    \end{minipage}
    \\[1.\bigskipamount]
    \rule{0.9\linewidth}{0.5mm}
  \end{center}
  \vfill\vfill
  
\begin{flushleft}
\footnotesize
\@ifundefined{c@@tempa}{\newcounter{@tempa}}{}%
\ifnum\the@member=0\relax%
  \ClassWarning{bordeaux-thesis}{No commission member have been given}{You can provide members using the command \string\addcommissionmember.}%
\else%
\textbf{Soutenue le :} {\@date{}}\\\medskip%
\setcounter{@tempa}{0}%
\begin{tabular}{@{}lcl}
\textbf{Apr\`es avis de : }%
\ifnum\value{@referee}>0\relax
\setcounter{@tempa}{0}%
\whiledo{\value{@tempa}<\value{@referee}}{%
  \stepcounter{@tempa}%
  \csname @referee@\the@tempa\endcsname\\%
}%
\fi  
\end{tabular}
\fi%
\\{\bf Devant la Commission d'examen form\'ee de :}\\\medskip%
\begin{tabular}{@{\enskip}lcl}
\setcounter{@tempa}{0}%
\whiledo{\value{@tempa}<\value{@member}}{%
        \stepcounter{@tempa}%
        \csname @member@\the@tempa\endcsname%
        \ifnum\value{@tempa}<\value{@member}\relax%
          \\%
        \fi%
      }%
\end{tabular}
\end{flushleft}

\begin{center}
\large
-- \@submityear{} --
\end{center} 
\normalsize
\newpage

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

\if@phd@print%
  \newgray{lightgray}{1}
    \hypersetup{
      colorlinks=true, %colorise les liens
      breaklinks=true, %permet le retour à la ligne dans les liens trop longs
      urlcolor= darkgray,  %couleur des hyperliens
      linkcolor= black, %couleur des liens internes
      plainpages=false,  %pour palier à "Bookmark problems can occur when you have duplicate page numbers, for example, if you have a page i and a page 1."
      citecolor=black % pour définir la couleur des liens de bibliographie
    }
  \newrgbcolor{marou}{0 0 0}%redéfinie cette couleur, pour notamment rendre les titres noirs, et aussi les résultats de la commande \gras{}
\fi