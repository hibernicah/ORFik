% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/experiment.R
\name{create.experiment}
\alias{create.experiment}
\title{Create a template for new ORFik \code{\link{experiment}}}
\usage{
create.experiment(
  dir,
  exper,
  saveDir = NULL,
  types = c("bam", "bed", "wig"),
  txdb = "",
  fa = "",
  viewTemplate = TRUE
)
}
\arguments{
\item{dir}{Which directory to create experiment from}

\item{exper}{Short name of experiment, max 5 characters long}

\item{saveDir}{Directory to save experiment csv file (NULL)}

\item{types}{Default (bam, bed, wig), which types of libraries to allow}

\item{txdb}{A path to gff/gtf file used for libraries}

\item{fa}{A path to fasta genome/sequences used for libraries}

\item{viewTemplate}{run View() on template when finished, default (TRUE)}
}
\value{
a data.frame, NOTE: this is not a ORFik experiment,
 only a template for it!
}
\description{
Create information on runs / samples from an experiment as a single R object.
By using files in a folder. It will try to make an experiment table
with information per sample. There will be several columns you can fill in,
most of there it will try to auto-detect. Like if it is RNA-seq or Ribo-seq,
Wild type or mutant etc.
You will have to fill in the details that were not autodetected.
Easiest way to fill in the blanks are in a csv editor like libre Office
or excel. Remember that each row (sample) must have a unique combination
of values.
An extra column called "reverse" is made if there are paired data,
like +/- strand wig files.
}
\examples{
# 1. Pick directory
dir <- system.file("extdata", "", package = "ORFik")
# 2. Pick an experiment name
exper <- "ORFik"
# 3. Pick .gff/.gtf location
txdb <- system.file("extdata", "annotations.gtf", package = "ORFik")
template <- create.experiment(dir = dir, exper, txdb = txdb,
                              viewTemplate = FALSE)
template$X5[6] <- "heart" # <- fix non unique row
# read experiment
df <- read.experiment(template)
# Save with: save.experiment(df, file = "path/to/save/experiment.csv")
}
\seealso{
Other ORFik_experiment: 
\code{\link{bamVarName}()},
\code{\link{experiment-class}},
\code{\link{libraryTypes}()},
\code{\link{outputLibs}()},
\code{\link{read.experiment}()},
\code{\link{save.experiment}()},
\code{\link{validateExperiments}()}
}
\concept{ORFik_experiment}
