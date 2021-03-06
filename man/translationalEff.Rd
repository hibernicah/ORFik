% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/riboseq_features.R
\name{translationalEff}
\alias{translationalEff}
\title{Translational efficiency}
\usage{
translationalEff(grl, RNA, RFP, tx, with.fpkm = FALSE, pseudoCount = 0)
}
\arguments{
\item{grl}{a \code{\link{GRangesList}} object
can be either transcripts, 5' utrs, cds', 3' utrs or
ORFs as a special case (uORFs, potential new cds' etc).}

\item{RNA}{RnaSeq reads as GAlignment, GRanges
or GRangesList object}

\item{RFP}{RiboSeq reads as GAlignment, GRanges
or GRangesList object}

\item{tx}{a GRangesList of the transcripts. If you used cage data, then
the tss for the the leaders have changed, therefor the tx lengths have
changed. To account for that call:
`
translationalEff(grl, RNA, RFP, tx = extendLeaders(tx, cageFiveUTRs))
` where cageFiveUTRs are the reannotated by CageSeq data leaders.}

\item{with.fpkm}{logical F, if true return the fpkm values together with
translational efficiency}

\item{pseudoCount}{an integer, 0, set it to 1 if you want to avoid NA and
inf values. It also helps against bias from low depth libraries.}
}
\value{
a numeric vector of fpkm ratios, if with.fpkm is TRUE, return a
data.table with te and fpkm values
}
\description{
Uses RnaSeq and RiboSeq to get translational efficiency of every element in
`grl`. Translational efficiency is defined as:
\preformatted{
(density of RPF within ORF) / (RNA expression of ORFs transcript)
}
}
\examples{
ORF <- GRanges(seqnames = "1",
               ranges = IRanges(start = c(1, 10, 20), end = c(5, 15, 25)),
               strand = "+")
grl <- GRangesList(tx1_1 = ORF)
RFP <- GRanges("1", IRanges(25, 25), "+")
RNA <- GRanges("1", IRanges(1, 50), "+")
tx <-  GRangesList(tx1 = GRanges("1", IRanges(1, 50), "+"))
# grl must have same names as cds + _1 etc, so that they can be matched.
te <- translationalEff(grl, RNA, RFP, tx, with.fpkm = TRUE, pseudoCount = 1)
te$fpkmRFP
te$te

}
\references{
doi: 10.1126/science.1168978
}
\seealso{
Other features: 
\code{\link{computeFeaturesCage}()},
\code{\link{computeFeatures}()},
\code{\link{disengagementScore}()},
\code{\link{distToCds}()},
\code{\link{distToTSS}()},
\code{\link{entropy}()},
\code{\link{floss}()},
\code{\link{fpkm_calc}()},
\code{\link{fpkm}()},
\code{\link{fractionLength}()},
\code{\link{initiationScore}()},
\code{\link{insideOutsideORF}()},
\code{\link{isInFrame}()},
\code{\link{isOverlapping}()},
\code{\link{kozakSequenceScore}()},
\code{\link{orfScore}()},
\code{\link{rankOrder}()},
\code{\link{ribosomeReleaseScore}()},
\code{\link{ribosomeStallingScore}()},
\code{\link{startRegionCoverage}()},
\code{\link{startRegion}()},
\code{\link{subsetCoverage}()}
}
\concept{features}
