% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ranges_helpers.R
\name{extendTrailers}
\alias{extendTrailers}
\title{Extend the Trailers transcription stop sites}
\usage{
extendTrailers(grl, extension = 1000L)
}
\arguments{
\item{grl}{usually a \code{\link{GRangesList}} of 3' utrs or transcripts.
Can be used for any extension of groups.}

\item{extension}{an integer, how much to extend the leaders.
Or a GRangesList where start / stops by strand are the positions
to use as new starts.}
}
\value{
an extended GRangeslist
}
\description{
Will extend the trailers or transcripts downstream by extension.
Remember the extension is general not relative, that means splicing
will not be taken into account.
Requires the \code{grl} to be sorted beforehand,
use \code{\link{sortPerGroup}} to get sorted grl.
}
\examples{
library(GenomicFeatures)
samplefile <- system.file("extdata", "hg19_knownGene_sample.sqlite",
                          package = "GenomicFeatures")
txdb <- loadDb(samplefile)
threeUTRs <- threeUTRsByTranscript(txdb) # <- extract only 5' leaders
tx <- exonsBy(txdb, by = "tx", use.names = TRUE)
## now try(extend downstream 1000):
extendTrailers(threeUTRs, extension = 1000)
## Or on transcripts
extendTrailers(tx, extension = 1000)

}
