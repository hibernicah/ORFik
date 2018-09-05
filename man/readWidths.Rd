% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gr_helpers.R
\name{readWidths}
\alias{readWidths}
\title{Get RiboSeq widths}
\usage{
readWidths(reads)
}
\arguments{
\item{reads}{a GRanges or GAlignment object.}
}
\value{
an integer vector of widths
}
\description{
Input a ribo-seq object and get width of reads, this is to avoid
confusion between width, qwidth and meta column containing original read
width.
}
\details{
If input is p-shifted and GRanges, the "$score" or "$size" colum" must
exist, and contain the original read widths. ORFik P-shifting creates a
$size column, other softwares like shoelaces creates a score column
}