% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{bedToGR}
\alias{bedToGR}
\title{Converts different type of files to Granges}
\usage{
bedToGR(x, bed6 = TRUE)
}
\arguments{
\item{x}{A \code{\link{data.frame}} from imported bed-file,
to convert to GRanges}

\item{bed6}{If bed6, no meta column is added}
}
\value{
a \code{\link{GRanges}} object from bed
}
\description{
column 5 will be set to score
Only Accepts bed files for now, standard format from Fantom5
}
\seealso{
Other utils: 
\code{\link{convertToOneBasedRanges}()},
\code{\link{fimport}()},
\code{\link{findFa}()},
\code{\link{fread.bed}()},
\code{\link{optimizeReads}()},
\code{\link{readBam}()},
\code{\link{readWig}()}
}
\concept{utils}
