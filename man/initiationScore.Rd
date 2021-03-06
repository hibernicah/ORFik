% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/riboseq_features.R
\name{initiationScore}
\alias{initiationScore}
\title{Get initiation score for a GRangesList of ORFs}
\usage{
initiationScore(grl, cds, tx, reads, pShifted = TRUE)
}
\arguments{
\item{grl}{a \code{\link{GRangesList}} object with ORFs}

\item{cds}{a \code{\link{GRangesList}} object with coding sequences}

\item{tx}{a GrangesList of transcripts covering grl.}

\item{reads}{ribosomal footprints, given as Galignment object or
Granges}

\item{pShifted}{a logical (TRUE), are riboseq reads p-shifted?}
}
\value{
an integer vector, 1 score per ORF, with names of grl
}
\description{
initiationScore tries to check how much each TIS region resembles, the
average of the CDS TIS regions.
}
\details{
Since this features uses a distance matrix for scoring, values are
distributed like this:
As result there is one value per ORF:
0.000: means that ORF had no reads
-1.000: means that ORF is identical to average of CDS
1.000: means that orf is maximum different than average of CDS
}
\examples{
# Good hiting ORF
ORF <- GRanges(seqnames = "1",
               ranges = IRanges(21, 40),
               strand = "+")
names(ORF) <- c("tx1")
grl <- GRangesList(tx1 = ORF)
# 1 width p-shifted reads
reads <- GRanges("1", IRanges(c(21, 23, 50, 50, 50, 53, 53, 56, 59),
                            width = 1), "+")
score(reads) <- 28 # original width
cds <- GRanges(seqnames = "1",
               ranges = IRanges(50, 80),
               strand = "+")
cds <- GRangesList(tx1 = cds)
tx <- GRanges(seqnames = "1",
               ranges = IRanges(1, 85),
               strand = "+")
tx <- GRangesList(tx1 = tx)

initiationScore(grl, cds, tx, reads, pShifted = TRUE)

}
\references{
doi: 10.1186/s12915-017-0416-0
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
\code{\link{subsetCoverage}()},
\code{\link{translationalEff}()}
}
\concept{features}
