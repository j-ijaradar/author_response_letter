\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{authorresponseletter}[2026/11/02 v3.0.0 Author response letters to journal reviewers]
% -----------------------------------------------------------------------------
%  authorresponseletter.cls
%  Author  : Jyotirmaya Ijaradar
%  License : GNU General Public License v3.0 (see LICENSE)
%
%  Features
%   - Class options: final, greyscale, compact, noautothanks,
%                    plainnumbers, continuousthanks
%   - Per-reviewer colours; shared colour for general comments
%   - Comment numbers R1.3 / E.1 (or plain 1, 2, 3)
%   - \commentref{<label>} / \commentref*{<label>} automatic cross-references
%   - Breakable comment boxes
%   - subcomments / subresponses environments for points (a), (b), ...
%   - revision environment for quoted revised text with location,
%     inline \added, \deleted, \replaced
%   - \authorcheck notes, hidden by the 'final' option with a warning
%   - coverletter environment, \signature, \onbehalf, \letterclosing
%   - Editable title page (\titleheading, \submittedto)
%   - \addressedin{} and \printoverview overview table
%   - Rotating thank-you notes, restarting for each reviewer
% -----------------------------------------------------------------------------

%%% Options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=rr,prefix=rr@opt@}
\DeclareBoolOption{final}            % hide \authorcheck notes
\DeclareBoolOption{greyscale}        % black-and-white printing
\DeclareBoolOption{compact}          % tighter spacing
\DeclareBoolOption{noautothanks}     % no automatic thank-you phrase
\DeclareBoolOption{plainnumbers}     % Comment 1 instead of Comment R1.1
\DeclareBoolOption{continuousthanks} % do not restart phrases per reviewer
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{scrartcl}}
\ProcessKeyvalOptions*
\LoadClass{scrartcl}

\RequirePackage[breakable,skins]{tcolorbox}
\RequirePackage{xcolor}
\RequirePackage{intcalc}
\RequirePackage{array}
\RequirePackage{longtable}
\IfFileExists{ulem.sty}{\RequirePackage[normalem]{ulem}}{%
	\ClassWarningNoLine{authorresponseletter}{ulem.sty not found: \string\deleted\space will not strike text through}%
	\providecommand{\sout}[1]{[#1]}\providecommand{\uline}[1]{\underline{#1}}}


%%% Metadata
\newcommand*{\journal}[1]{\renewcommand*{\@journal}{#1}}
\newcommand*{\@journal}{}
\newcommand*{\editorname}[1]{\renewcommand*{\@editorname}{#1}}
\newcommand*{\@editorname}{}
\newcommand*{\manuscript}[1]{\renewcommand*{\@manuscript}{#1}}
\newcommand*{\@manuscript}{}
\newcommand*{\titleheading}[1]{\renewcommand*{\@titleheading}{#1}}
\newcommand*{\@titleheading}{Response to Reviewers' Comments}
\newcommand*{\submittedto}[1]{\renewcommand*{\@submittedto}{#1}}
\newcommand*{\@submittedto}{Revised manuscript submitted to}
\newcommand*{\signature}[1]{\renewcommand*{\@signature}{#1}}
\newcommand*{\@signature}{\@author}
\newcommand*{\onbehalf}[1]{\renewcommand*{\@onbehalf}{#1}}
\newcommand*{\@onbehalf}{On behalf of all authors}
\newcommand*{\letterclosing}[1]{\renewcommand*{\@letterclosing}{#1}}
\newcommand*{\@letterclosing}{Yours sincerely,}

\newcommand*{\thetitle}{\@title}
\newcommand*{\theauthor}{\@author}
\newcommand*{\thedate}{\@date}
\newcommand*{\theeditor}{\@editorname}
\newcommand*{\themanuscript}{\@manuscript}


%%% Colors
% Active comment colours (switched automatically by \editor and \reviewer)
\definecolor{colorcommentfg}{RGB}{0,63,87}
\definecolor{colorcommentbg}{HTML}{e0f0f6}
\definecolor{colorcommentframe}{RGB}{0,112,155}

% General comments: one colour for the editor and all reviewers
\definecolor{colorgeneralfg}{HTML}{5C3D00}
\definecolor{colorgeneralbg}{HTML}{FFF4DC}
\definecolor{colorgeneralframe}{HTML}{C98A00}

% Revised text boxes
\definecolor{colorchangefg}{HTML}{24323D}
\definecolor{colorchangebg}{HTML}{F5F7F9}
\definecolor{colorchangeframe}{HTML}{7A8B99}

\colorlet{colorconcludingresponsefg}{black!80}
\colorlet{colorconcludingresponsebg}{black!2}
\colorlet{colorconcludingresponseframe}{black!20}

% Inline changes and author notes
\colorlet{coloradded}{blue!70!black}
\colorlet{colordeleted}{red!70!black}
\colorlet{colorauthornote}{red!65!black}
\colorlet{rr@linkcolor}{blue!55!black}  % link colour (override with \hypersetup)

% Colour schemes: rev<scheme>fg / rev<scheme>bg / rev<scheme>frame
\definecolor{reveditorfg}{HTML}{2E3440}
\definecolor{reveditorbg}{HTML}{ECEFF4}
\definecolor{reveditorframe}{HTML}{4C566A}
\definecolor{rev1fg}{RGB}{0,63,87}        % blue
\definecolor{rev1bg}{HTML}{e0f0f6}
\definecolor{rev1frame}{RGB}{0,112,155}
\definecolor{rev2fg}{HTML}{1B4D2B}        % green
\definecolor{rev2bg}{HTML}{E3F4E8}
\definecolor{rev2frame}{HTML}{2E8B4E}
\definecolor{rev3fg}{HTML}{3F1D5C}        % purple
\definecolor{rev3bg}{HTML}{EFE6F7}
\definecolor{rev3frame}{HTML}{7B3FA8}
\definecolor{rev4fg}{HTML}{5C1322}        % crimson
\definecolor{rev4bg}{HTML}{F9E4E8}
\definecolor{rev4frame}{HTML}{B02A44}
\definecolor{rev5fg}{HTML}{0F4A47}        % teal
\definecolor{rev5bg}{HTML}{DFF3F1}
\definecolor{rev5frame}{HTML}{1A8A83}
\definecolor{rev6fg}{HTML}{4A2E17}        % brown
\definecolor{rev6bg}{HTML}{F3EAE1}
\definecolor{rev6frame}{HTML}{8B5A2B}
\newcommand*{\rr@nschemes}{6}

\ifrr@opt@greyscale
	\colorlet{colorgeneralfg}{black}
	\colorlet{colorgeneralbg}{black!12}
	\colorlet{colorgeneralframe}{black!55}
	\colorlet{colorchangefg}{black}
	\colorlet{colorchangebg}{black!3}
	\colorlet{colorchangeframe}{black!45}
	\colorlet{coloradded}{black}
	\colorlet{colordeleted}{black}
	\colorlet{colorauthornote}{black}
	\colorlet{rr@linkcolor}{black}
	\colorlet{reveditorfg}{black}
	\colorlet{reveditorbg}{black!5}
	\colorlet{reveditorframe}{black!70}
	\@for\rr@i:={1,2,3,4,5,6}\do{%
		\colorlet{rev\rr@i fg}{black}%
		\colorlet{rev\rr@i bg}{black!5}%
		\colorlet{rev\rr@i frame}{black!70}%
	}
\fi

% \setreviewercolors{<n or editor>}{<fg>}{<bg>}{<frame>}
\newcommand*{\setreviewercolors}[4]{%
	\colorlet{rev#1fg}{#2}\colorlet{rev#1bg}{#3}\colorlet{rev#1frame}{#4}}
% \setgeneralcolors{<fg>}{<bg>}{<frame>}
\newcommand*{\setgeneralcolors}[3]{%
	\colorlet{colorgeneralfg}{#1}\colorlet{colorgeneralbg}{#2}\colorlet{colorgeneralframe}{#3}}

\newcommand*{\rr@usescheme}[1]{%
	\colorlet{colorcommentfg}{rev#1fg}%
	\colorlet{colorcommentbg}{rev#1bg}%
	\colorlet{colorcommentframe}{rev#1frame}%
}


%%% General Settings
\setlength{\parindent}{0pt}
\setlength{\parskip}{.3em plus .2em minus .3em}
\ifrr@opt@compact
	\renewcommand{\baselinestretch}{1.2}
	\newcommand*{\rr@responsegap}{\vspace{2em plus 0.2em minus 1em}}
\else
	\renewcommand{\baselinestretch}{1.5}
	\newcommand*{\rr@responsegap}{\vspace{4em plus 0.2em minus 1.5em}}
\fi
\widowpenalty10000
\clubpenalty10000


%%% Counters and numbering
\newcounter{reviewer}
\newcounter{revcomment}[reviewer]
\newcounter{revsub}[revcomment]
\newcounter{revsubresp}

\newcommand*{\rr@prefix}{R\arabic{reviewer}}   % E or R<n>
\newcommand*{\rr@whoname}{Reviewer~\arabic{reviewer}}
\newcommand*{\therecipient}{reviewer}
\newcommand*{\rr@cid}{}       % unique id of the current comment, e.g. R1.3
\newcommand*{\rr@plaincur}{}  % plain number of the current (sub)comment, e.g. 3(a)

\ifrr@opt@plainnumbers
	\renewcommand*{\therevcomment}{\arabic{revcomment}}
\else
	\renewcommand*{\therevcomment}{\rr@prefix.\arabic{revcomment}}
\fi
\renewcommand*{\therevsub}{\therevcomment(\alph{revsub})}


%%% Title page
\renewcommand*{\maketitle}{%
	\begin{titlepage}
		\centering
		\vspace*{2cm}
		{\Large \@titleheading\par}
		\vspace{1.5cm}
		{\LARGE\bfseries \@title\par}
		\vspace{1.5cm}
		{\large \@submittedto\par}
		\vspace{0.3em}
		{\Large\itshape \@journal\par}
		\ifx\@manuscript\@empty\else
			\vspace{0.8em}
			{\large Manuscript No.~\@manuscript\par}
		\fi
		\vspace{1.5cm}
		{\large \@author\par}
		\vspace{1cm}
		{\large \@date\par}
	\end{titlepage}
}


%%% Sections
\newcommand*{\rr@bookmark}[2]{\ifdefined\pdfbookmark\pdfbookmark[1]{#1}{#2}\fi}

\NewDocumentEnvironment{coverletter}{O{Dear Editor,}}{%
	\clearpage
	\rr@bookmark{Cover Letter}{hyperref@coverletter}%
	\noindent #1\par\medskip
}{%
	\par\bigskip
	\noindent\@letterclosing\par
	\vspace{0.5em}
	\noindent\@signature
	\ifx\@onbehalf\@empty\else\\\@onbehalf\fi\par
}

\newcommand*{\editor}{%
	\clearpage
	\rr@usescheme{editor}%
	\renewcommand*{\therecipient}{editor}%
	\renewcommand*{\rr@prefix}{E}%
	\renewcommand*{\rr@whoname}{Editor}%
	\setcounter{revcomment}{0}%
	\rr@resetthanks
	\rr@bookmark{Response to the Editor}{hyperref@editor}%
	\section*{Authors' Response to the Editor}%
}

\newcommand*{\reviewer}{%
	\clearpage
	\refstepcounter{reviewer}%
	\edef\rr@tmp{\noexpand\rr@usescheme{\intcalcInc{\intcalcMod{\intcalcDec{\arabic{reviewer}}}{\rr@nschemes}}}}\rr@tmp
	\renewcommand*{\therecipient}{reviewer}%
	\renewcommand*{\rr@prefix}{R\arabic{reviewer}}%
	\renewcommand*{\rr@whoname}{Reviewer~\arabic{reviewer}}%
	\rr@resetthanks
	\rr@bookmark{Reviewer \arabic{reviewer}}{hyperref@reviewer\arabic{reviewer}}%
	\protected@edef\rr@tmp{Authors' Response to Reviewer~\arabic{reviewer}}%
	\expandafter\section\expandafter*\expandafter{\rr@tmp}%
}


%%% Cross-references
% \commentref{lab}  -> "Reviewer 1, Comment 3"   (linked)
% \commentref*{lab} -> "Comment R1.3"            (linked)
\newcommand*{\rr@newcref}[3]{%
	\expandafter\gdef\csname rr@crefl@#1\endcsname{#2}%
	\expandafter\gdef\csname rr@crefs@#1\endcsname{#3}}
\newcommand*{\rr@writecref}[1]{%
	\begingroup
	\let\protect\@unexpandable@protect
	\immediate\write\@auxout{\string\rr@newcref{#1}{\rr@whoname, Comment~\rr@plaincur}{Comment~\@currentlabel}}%
	\endgroup
}
\newcommand*{\rr@installlabel}{%
	\let\rr@origlabel\label
	\def\label##1{\rr@origlabel{##1}\rr@writecref{##1}}%
}
\newcommand{\rr@linkto}[2]{\ifdefined\hyperref\hyperref[#1]{#2}\else #2\fi}
\NewDocumentCommand{\commentref}{sm}{%
	\@ifundefined{rr@crefl@#2}{%
		\textbf{??}\G@refundefinedtrue
		\ClassWarning{authorresponseletter}{Comment reference `#2' undefined}%
	}{%
		\rr@linkto{#2}{\IfBooleanTF{#1}{\@nameuse{rr@crefs@#2}}{\@nameuse{rr@crefl@#2}}}%
	}%
}


%%% Thank-you notes
%   \addthankyou{<text>}   append a phrase      \clearthankyou   remove all
%   \thankyou{<n>}         print phrase n       \autothanksoff / \autothankson
\newcount\rr@thankscount
\newcount\rr@responsecount
\newif\ifrr@autothanks
\rr@autothankstrue
\ifrr@opt@noautothanks\rr@autothanksfalse\fi

\newcommand{\addthankyou}[1]{%
	\global\advance\rr@thankscount by 1
	\expandafter\gdef\csname rr@thanks@\the\rr@thankscount\endcsname{#1}}
\newcommand*{\clearthankyou}{\global\rr@thankscount=0 }
\newcommand*{\thankyou}[1]{\csname rr@thanks@#1\endcsname}
\newcommand*{\autothanksoff}{\rr@autothanksfalse}
\newcommand*{\autothankson}{\rr@autothankstrue}
\newcommand*{\rr@resetthanks}{\ifrr@opt@continuousthanks\else\global\rr@responsecount=0 \fi}

% Prints the next phrase and ends the paragraph; with no phrase the
% response text continues on the same line as "Response:".
\newcommand*{\rr@autothanks}{%
	\ifrr@autothanks
		\ifnum\rr@thankscount>0
			\global\advance\rr@responsecount by 1
			\ \thankyou{\intcalcInc{\intcalcMod{\intcalcDec{\the\rr@responsecount}}{\the\rr@thankscount}}}\par
		\else\expandafter\expandafter\expandafter\rr@samepara
		\fi
	\else\expandafter\rr@samepara
	\fi
}
\newcommand*{\rr@samepara}{\ \ignorespaces}
% #1 = optional argument (or -NoValue-), #2 = default opening when absent
\newcommand{\rr@opening}[2]{%
	\IfNoValueTF{#1}{#2}{%
		\if\relax\detokenize{#1}\relax\expandafter\rr@samepara
		\else\ #1\par\fi}}

\addthankyou{We thank the \therecipient{} for this valuable suggestion.}
\addthankyou{Thank you for pointing this out.}
\addthankyou{We appreciate the \therecipient's careful reading and this helpful remark.}
\addthankyou{We are grateful to the \therecipient{} for raising this important point.}
\addthankyou{Thank you for this constructive suggestion.}
\addthankyou{We thank the \therecipient{} for this insightful observation.}
\addthankyou{We appreciate the \therecipient{} bringing this to our attention.}
\addthankyou{Thank you for this comment.}

\newcommand*{\rr@generaltext}{We sincerely thank the \therecipient{} for the time and effort invested in reviewing our manuscript, and for the thoughtful and constructive feedback, which has helped us to improve the quality of the paper considerably. We have carefully considered all comments and suggestions, and we address each of them point by point below.}
\newcommand{\generalresponsetext}[1]{\renewcommand*{\rr@generaltext}{#1}}


%%% Author notes
\newcount\rr@notecount
\newcommand{\authorcheck}[1]{%
	\global\advance\rr@notecount by 1
	\ifrr@opt@final\else
		\par\smallskip
		{\color{colorauthornote}\noindent\textbf{AUTHOR CHECK: }#1\par}%
		\smallskip
	\fi
}
\AtEndDocument{%
	\ifnum\rr@notecount>0
		\ClassWarningNoLine{authorresponseletter}{\the\rr@notecount\space \string\authorcheck\space note(s) remain in the document\ifrr@opt@final\space (hidden by the 'final' option)\fi}%
	\fi
}


%%% Inline changes: \added{new}, \deleted{old}, \replaced{new}{old}
\newcommand{\rr@added}[1]{\ifrr@opt@greyscale\uline{#1}\else{\color{coloradded}#1}\fi}
\newcommand{\rr@deleted}[1]{{\color{colordeleted}\sout{#1}}}
\newcommand{\rr@replaced}[2]{\rr@added{#1} \rr@deleted{#2}}
\AtBeginDocument{% do not clash with the 'changes' package
	\@ifundefined{added}{\let\added\rr@added}{}%
	\@ifundefined{deleted}{\let\deleted\rr@deleted}{}%
	\@ifundefined{replaced}{\let\replaced\rr@replaced}{}%
}


%%% Overview table
%   \addressedin{Section 2.3}  inside a revresponse
%   \printoverview             prints the table (needs two compilations)
\newcommand*{\overviewname}{Overview of Revisions}
\newcommand*{\rr@where}{}
\newcommand{\addressedin}[1]{\gdef\rr@where{#1}}
\newcommand*{\rr@ovlist}{}
\newcommand*{\rr@ovitem}[4]{\g@addto@macro\rr@ovlist{\rr@ovrow{#1}{#2}{#3}{#4}}}
\newcommand*{\rr@writeoverview}{%
	\ifx\rr@cid\@empty\else
		\begingroup
		\let\protect\@unexpandable@protect
		\immediate\write\@auxout{\string\rr@ovitem{\rr@whoname}{\therevcomment}{\rr@cid}{\unexpanded\expandafter{\rr@where}}}%
		\endgroup
	\fi
	\global\let\rr@where\@empty
}
\newcommand{\rr@ovrow}[4]{%
	#1 & \rr@linkto{rr@c@#3}{#2} & \if\relax\detokenize{#4}\relax ---\else #4\fi & \pageref{rr@c@#3}\\}
\newcommand{\printoverview}{%
	\clearpage
	\rr@bookmark{\overviewname}{hyperref@overview}%
	\section*{\overviewname}
	\ifx\rr@ovlist\@empty
		\textit{The overview table appears after the next compilation.}\par
	\else
		\begingroup
		\renewcommand{\arraystretch}{1.1}%
		\begin{longtable}{@{}>{\raggedright}p{0.2\linewidth}>{\raggedright}p{0.14\linewidth}>{\raggedright\arraybackslash}p{0.48\linewidth}r@{}}
			\textbf{From} & \textbf{Comment} & \textbf{Addressed in} & \textbf{Page}\\
			\hline\endhead
			\rr@ovlist
		\end{longtable}
		\endgroup
	\fi
}


%%% Blocks
\newenvironment{generalcomment}{%
	\begin{tcolorbox}[enhanced jigsaw, breakable, attach title to upper, title={General Comments}, after title={.\enskip}, fonttitle={\bfseries}, coltitle={colorgeneralfg}, colback={colorgeneralbg}, colframe={colorgeneralframe}, bookmark={General Comments}]
	}{\end{tcolorbox}}

% \begin{generalresponse}            default opening + your text
% \begin{generalresponse}[Text.]     your own opening
% \begin{generalresponse}[]          no opening sentence
\NewDocumentEnvironment{generalresponse}{o}{%
	\textbf{Response:}\rr@opening{#1}{\ \rr@generaltext\par}%
}{\par\rr@responsegap}

\newenvironment{revcomment}[1][]{%
	\refstepcounter{revcomment}%
	\xdef\rr@cid{\rr@prefix.\arabic{revcomment}}%
	\edef\rr@plaincur{\arabic{revcomment}}%
	\label{rr@c@\rr@cid}%
	\begin{tcolorbox}[enhanced jigsaw, breakable, adjusted title={Comment \therevcomment}, fonttitle={\bfseries}, colback={colorcommentbg}, colframe={colorcommentframe}, coltitle={colorcommentbg}, bookmark={Comment \therevcomment}, #1]
	\rr@installlabel
	}{\end{tcolorbox}}

% Points inside a comment: \item -> (a), (b), ... ; \label gives "Comment R1.3(a)"
\newenvironment{subcomments}{%
	\begin{list}{(\alph{revsub})}{\usecounter{revsub}%
		\setlength{\leftmargin}{2em}\setlength{\labelwidth}{1.6em}%
		\setlength{\itemsep}{0.2em}\setlength{\topsep}{0.3em}}%
	\let\rr@olditem\item
	\def\item{\rr@olditem\edef\rr@plaincur{\arabic{revcomment}(\alph{revsub})}}%
	}{\end{list}}

% Matching answers inside a response: \item -> (a), (b), ...
\newenvironment{subresponses}{%
	\begin{list}{\textbf{(\alph{revsubresp})}}{\usecounter{revsubresp}%
		\setlength{\leftmargin}{2em}\setlength{\labelwidth}{1.6em}%
		\setlength{\itemsep}{0.3em}\setlength{\topsep}{0.3em}}%
	}{\end{list}}

% \begin{revresponse}               rotating automatic thank-you
% \begin{revresponse}[Own thanks.]  your own thank-you
% \begin{revresponse}[]             no thank-you sentence
\NewDocumentEnvironment{revresponse}{o}{%
	\textbf{Response:}\rr@opening{#1}{\rr@autothanks}%
}{%
	\par
	\rr@writeoverview
	\rr@responsegap
}

% Quoted revised text: \begin{revision}[Section 2.3, p. 7, ll. 120--135]
\NewDocumentEnvironment{revision}{o}{%
	\IfNoValueTF{#1}{%
		\begin{tcolorbox}[enhanced jigsaw, breakable, colback={colorchangebg}, colframe={colorchangeframe}, coltext={colorchangefg}, boxrule=0pt, leftrule=3pt, arc=0pt, outer arc=0pt]%
	}{%
		\begin{tcolorbox}[enhanced jigsaw, breakable, colback={colorchangebg}, colframe={colorchangeframe}, coltext={colorchangefg}, boxrule=0pt, leftrule=3pt, arc=0pt, outer arc=0pt, title={Revised text (#1)}, fonttitle={\small\bfseries}, coltitle={colorchangefg}, colbacktitle={colorchangebg}, titlerule=0pt, bottomtitle=0pt]%
	}%
}{\end{tcolorbox}}
\newenvironment{changes}{\begin{revision}}{\end{revision}}

\newenvironment{concludingresponse}[1][]{%
	\begin{tcolorbox}[attach title to upper, breakable, title={Concluding Response #1}, after title={.\enskip}, fonttitle={\bfseries}, coltitle={colorconcludingresponsefg}, colback={colorconcludingresponsebg}, colframe={colorconcludingresponseframe},]
	}{\end{tcolorbox}}

\newcommand{\printpartbibliography}[1]{\begin{refsegment}\nocite{#1}\printbibliography[heading=none,segment=\therefsegment]\end{refsegment}}


%%% hyperref integration
\providecommand*{\revcommentautorefname}{Comment}
\AddToHook{package/hyperref/after}{
	\hypersetup{
		bookmarksopen,
		colorlinks=true,
		allcolors={rr@linkcolor},
		pdfcreator={LaTeX with the authorresponseletter class},
	}
}
\AddToHook{begindocument/before}{
	\IfPackageLoadedTF{hyperref}{
		\hypersetup{
			pdfauthor={\@author},
			pdftitle={Review Response -- \@title{}},
			pdfkeywords={\@journal{}, \@manuscript{}, review response}
		}
	}{}
}
\AddToHook{begindocument/end}{\def\sectionautorefname{Reviewer}}
