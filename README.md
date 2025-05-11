\documentclass[12pt]{report}
\usepackage[utf8]{inputenc}
\usepackage[brazil]{babel}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{float}
\usepackage{caption}
\usepackage{hyperref}

\title{Projeto de Contador - Sistemas Digitais}
\author{Pedro Arthur Oliveira dos Santos}
\author{Lucas Matheus da Silva Lima}
\date{\today}

\begin{document}

\maketitle
\tableofcontents
\newpage

\chapter{Introdução}

Este relatório descreve os procedimentos realizados para a concepção do primeiro projeto da disciplina de Sistemas Digitais (ELE3515). Foi proposto projetar um contador, para realizar várias operações com dois números de 8 bits, além dos códigos em VHDL e testes no kit da DE2.

Trata-se de um projeto de circuito digital a nível de componentes menores que podem ser combinados a fim de formar vários componentes maiores para fazer as operações em todos esses números de bits.

A Figura~\ref{fig:contador} mostra detalhadamente o esquema inicial do projeto proposto.

\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\linewidth]{figuras/projeto_contador.png}
    \caption{Esquemático do Projeto do Contador}
    \label{fig:contador}
\end{figure}

\chapter{Referencial Teórico}

O projeto do contador inclui dois conteúdos importantíssimos dos livros de sistemas digitais: lógica combinacional e lógica sequencial. Especialmente a lógica sequencial introduz novos elementos à teoria dos circuitos digitais, que agora além da lógica combinacional, exige circuitos capazes de armazenar estados.

\section{Lógica Sequencial}

Circuitos combinacionais produzem uma saída diferente para cada entrada \cite{vahid}, porém há circuitos que não seguem esse comportamento — os chamados circuitos sequenciais. Eles podem produzir saídas diferentes para as mesmas entradas, de acordo com variáveis internas chamadas variáveis de estado \cite{vahid}. Essas variáveis são úteis para descrever circuitos que seguem uma lógica interna e armazenam bits.

\subsection{Latch SR}

Um circuito com realimentação que consegue armazenar o estado atual é o Latch SR, com entradas SET e RESET. Dependendo das entradas, ele mantém o estado anterior da saída \cite{vahid}. A topologia usando portas NOR está na Figura~\ref{fig:latch}.

\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\linewidth]{figuras/latch_sr.png}
    \caption{Latch SR com Portas NOR}
    \label{fig:latch}
\end{figure}

As equações do circuito são:

\begin{equation}
    t^{i+1} = \overline{S+Q^i} = \overline{S} \cdot \overline{Q^i}
\end{equation}

\begin{equation}
    Q^{i+1} = \overline{R+t^i} = \overline{R} \cdot \overline{t^i}
\end{equation}

Substituindo (1) em (2):

\begin{equation}
    Q^{i+1} = \overline{R} \cdot \overline{ \overline{S} \cdot \overline{Q^i} }
\end{equation}

Aplicando a Lei de De Morgan:

\begin{equation}
    Q^{i+1} = \overline{R} \cdot ( S + Q^i ) = \overline{R} \cdot S + \overline{R} \cdot Q^i  
\end{equation}

Essa equação mostra que, enquanto SET permanecer inalterado, a saída futura será igual à passada.

\subsection{Flip-Flop}

Um flip-flop é um circuito digital que, quando pulsado, pode armazenar 1 bit. Muitos flip-flops têm entrada \textit{clear}, usada para zerar a saída. A pulsação (clock) determina se o flip-flop atualiza ou retém o valor na saída, conforme a equação característica \cite{vahid}.

\subsubsection{Flip-Flop JK}

O flip-flop JK aprimora o funcionamento do flip-flop SR, interpretando S = R = 1 como comando de inversão \cite{tocci}. Os comandos:

\begin{itemize}
    \item J = 1, K = 0 → Set
    \item J = 0, K = 1 → Reset
    \item J = K = 1 → Toggle (inversão)
\end{itemize}

Equação característica:

\begin{equation}
    Q^{i+1} = J \cdot \overline{Q^i} + \overline{K} \cdot Q^i
\end{equation}

Ele também pode dividir a frequência de entrada (divisor de frequência). Veja a Figura~\ref{fig:jk}.

\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\linewidth]{figuras/FFJK.png}
    \caption{Flip-Flop JK}
    \label{fig:jk}
\end{figure}

\subsubsection{Flip-Flop D}

Muito utilizado em registradores, o flip-flop D armazena bits de forma seletiva \cite{tocci}. A equação característica:

\begin{equation}
    Q^{i+1} = D \cdot clk^{\rightarrow}
\end{equation}

Ou seja, a saída é igual à entrada nas bordas de subida. Figura~\ref{fig:ffd}.

\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\linewidth]{figuras/FFD.png}
    \caption{Flip-Flop D}
    \label{fig:ffd}
\end{figure}

\section{Máquina de Estados Finitos}

Em muitos casos, circuitos digitais operam de acordo com estados definidos por variáveis internas \cite{tocci}. A representação dos estados e transições é chamada de máquina de estados finitos — fundamental em projetos digitais.

\subsection{Variáveis de Estado}

As variáveis de estado determinam as transições entre os estados do sistema.

\section{Soma em BCD}

Para realizar somas em BCD (Binary-Coded Decimal), somamos unidades com unidades, dezenas com dezenas. Existem dois casos:

\subsection{Soma Menor ou Igual a 9}

Somamos normalmente em binário:

\begin{equation}
    0101 + 0100 = 1001
\end{equation}

\subsection{Soma Maior que 9}

Neste caso, soma-se binário + 6 para correção. Exemplo: 6 + 7 = 13

\begin{equation}
    0110 + 0111 = 1101
\end{equation}

\begin{equation}
    1101 + 0110 = 0011
\end{equation}

Com carry:

\begin{equation}
    0110 + 0111 = 0001 \: 0011
\end{equation}

\chapter{Projeto}

\section{Projetando os Blocos do Circuito}

O contador projetado é sequencial, com fases complexas: passo variável, modo crescente e decrescente.

\section{Somador BCD}

Usando somadores completos de 1 bit em cascata (8 somadores), obtemos um somador de 8 bits.

\section{Multiplexador de 2 Canais}

Multiplexadores escolhem entre entradas com base em uma chave seletora \cite{vahid}. Para este projeto, usamos um mux 2:1 de 12 bits.

O mux 2:1 possui entradas \(I_0\), \(I_1\), seleção \(S\) e saída \(Y\).

\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\linewidth]{figuras/Multiplexador_1_bit.png}
    \caption{Esquemático do multiplexador simples}
    \label{fig:mux}
\end{figure}

\begin{table}[H]
\centering
\caption{Tabela Verdade do Multiplexador}
\begin{tabular}{|c|c|c|c|}
\hline
\textbf{S} & \textbf{\(I_0\)} & \textbf{\(I_1\)} & \textbf{Y} \\
\hline
0 & 0 & 0 & 0 \\
0 & 0 & 1 & 0 \\
0 & 1 & 0 & 1 \\
0 & 1 & 1 & 1 \\
1 & 0 & 0 & 0 \\
1 & 0 & 1 & 1 \\
1 & 1 & 0 & 0 \\
\hline
\end{tabular}
\end{table}

\chapter{Conclusão}

\noindent Neste relatório foi descrita toda a concepção teórica do projeto de contador com circuitos digitais básicos. O desenvolvimento em VHDL e os testes na placa DE2 completam o ciclo prático da disciplina.

\begin{thebibliography}{9}

\bibitem{vahid}
Frank Vahid, \textit{Sistemas Digitais: Design com VHDL}, Bookman, 2008.

\bibitem{tocci}
Ronald J. Tocci, Neal S. Widmer, Gregory L. Moss, \textit{Sistemas Digitais: Princípios e Aplicações}, Pearson.

\end{thebibliography}

\end{document}
