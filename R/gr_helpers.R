#' Group GRanges
#'
#' It will group / split the GRanges object by the argument other:
#' I.g. if you want to group by gene, set other = gene_names
#'
#' if argument other is not specified it will use the names of
#' the GRanges object.
#' It will then be similar to split(gr, names(gr))
#'
#' It is important that all groups are unique, else they will be
#' grouped together.
#' @param gr a GRanges object
#' @param other a vector of unique names to group by
#' @importFrom S4Vectors nrun
#' @examples
#' ORFranges <- GRanges(seqnames = Rle(rep("1", 3)),
#'            ranges = IRanges(start = c(1, 10, 20),
#'            end = c(5, 15, 25)),
#'            strand = "+")
#'
#' ORFranges2 <- GRanges("1",
#'                      ranges = IRanges(start = c(20, 30, 40),
#'                                       end = c(25, 35, 45)),
#'                      strand = "+")
#' names(ORFranges) = rep("tx1_1",3)
#' names(ORFranges2) = rep("tx1_2",3)
#' grl <- GRangesList(tx1_1 = ORFranges, tx1_2 = ORFranges2)
#' gr <- unlist(grl, use.names = FALSE)
#' ## now recreate the grl
#' ## group by orf
#' grltest <- groupGRangesBy(gr) # using the names to group
#' identical(grl, grltest) ## they are identical
#'
#' ## group by transcript
#' names(gr) <- txNames(gr)
#' grltest <- groupGRangesBy(gr)
#' identical(grl, grltest) ## they are not identical
#'
#' @export
#' @return a GRangesList named after names(Granges) if other is NULL, else
#' names are from unique(other)
#'
groupGRangesBy <- function(gr, other = NULL){
  if (class(gr) != "GRanges") stop("gr must be GRanges Object")
  if (is.null(other)) { # if not using other
    if (is.null(names(gr))) stop("gr object have no names")
    l <- S4Vectors::Rle(names(gr))
  } else { # else use other
    if (length(gr) != length(other))
      stop(" in GroupGRangesByOther: lengths of gr and other does not match")
    l <- S4Vectors::Rle(other)
  }
  grouping <- unlist(lapply(1:nrun(l), function(x){ rep(x, runLength(l)[x])}))
  grl <- split(gr, grouping)
  if (is.null(other)) {
    names(grl) <- unique(names(gr))
  } else {
    names(grl) <- unique(other)
  }

  return(grl)
}


#' Get Ribo-seq widths
#'
#' Input a ribo-seq object and get width of reads,
#'  if input is p-shifted and GRanges, the "$score column" must
#'  exist, and contain the original read widths.
#' @param reads a GRanges or GAlignment object.
#' @return an integer vector of widths
riboSeqReadWidths <- function(reads){

  if (class(reads) == "GRanges"){
    rfpWidth <- width(reads)
    is.one_based <- all(as.integer(rfpWidth) == rep(1, length(rfpWidth)))
    if (is.one_based ) {
      if (is.null(reads$score)) {
        message("All widths are 1, If ribo-seq is p-shifted,\n
             score column should contain widths of read,\n
                will continue using 1-widths")
      } else {
        message("All widths are 1, using score column for widths, remove
                 score column and run again if this is wrong.")
        rfpWidth <- reads$score
      }
    }
  } else {
    rfpWidth <- qwidth(reads)
  }
  return(rfpWidth)
}