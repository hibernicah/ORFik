% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{fimport}
\alias{fimport}
\title{Load any type of sequencing reads}
\usage{
fimport(path, chrStyle = NULL)
}
\arguments{
\item{path}{a character path to file or a GRanges/Galignment object etc.
Any Ranged object.}

\item{chrStyle}{a GRanges object, or a \code{\link{seqlevelsStyle}}
(Default: NULL) to get seqlevelsStyle from. Is chromosome 1
called chr1 or 1, is mitocondrial chromosome called MT or chrM etc.
Will use 1st seqlevel-style if more are present.
Like: c("NCBI", "UCSC") -> pick "NCBI"}
}
\value{
a \code{\link{GAlignments}}/\code{\link{GRanges}} object,
 depending on input.
}
\description{
Wraps around rtracklayer::import and tries to speed up loading with the
use of data.table. Supports gzip, gz, bgz compression formats.
Also safer chromosome naming with the argument chrStyle
}
\details{
NOTE: For wig you can send in 2 files, so that it automaticly merges
forward and reverse stranded objects. You can also just send 1 wig file,
it will then have "*" as strand.
}
\examples{
bam_file <- system.file("extdata", "ribo-seq.bam", package = "ORFik")
fimport(bam_file)
# Certain chromosome naming
fimport(bam_file, "NCBI")

}
\seealso{
Other utils: 
\code{\link{bedToGR}()},
\code{\link{convertToOneBasedRanges}()},
\code{\link{findFa}()},
\code{\link{fread.bed}()},
\code{\link{optimizeReads}()},
\code{\link{readBam}()},
\code{\link{readWig}()}
}
\concept{utils}
