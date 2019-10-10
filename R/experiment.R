#' experiment class definition
#'
#' An object to massivly simplify your coding, it is
#' similar to systempipeR's 'target' table. By containing
#' filepaths and info for each library in some experiment.
#'
#' Simplest way to make is to call create.experiment on some
#' folder with libraries and see what you get. Some of the fields
#' might be needed to fill in manually. The important thing is
#' that each row must be unique (excluding filepath), that means
#' if it has replicates then that must be said explicit. And all
#' filepaths must be unique and have files with size > 0.
#' Syntax:
#' libtype (library type): rna-seq, ribo-seq, CAGE etc.
#' rep (replicate): 1,2,3 etc
#' condition: WT (wild-type), control, target, mzdicer, starved etc.
#' fraction: 18, 19 (fractinations), or other ways to split library.
#' filepath: Full filepath to file
#' @export
experiment <- setClass("experiment",
                       slots=list(experiment = "character",
                                  txdb = "character",
                                  fafile = "character",
                                  expInVarName = "logical"),
                       contains = "DataFrame")

#' experiment show definition
#'
#' Show a simplified version of experiment.
#' @param object an ORFik experiment
#' @export
setMethod("show",
          "experiment",
          function(object) {
            cat("experiment:", object@experiment, "with",
                length(unique(object@listData$libtype)), "library types and",
                length(object@listData$libtype), "runs","\n")

            obj <- as.data.table(as(object@listData, Class = "DataFrame"))
            if (nrow(obj) > 0) {
              obj <- obj[,-"filepath"]
              skip <- c()
              for (i in 2:ncol(obj)) {
                if (nrow(unique(obj[,i, with = F])) == 1)
                  skip <- c(skip, i)
              }
              if (length(skip) > 0) {
                show(obj[,-skip, with = F])
              } else show(obj)
            }
          }
)

#' Internal nrow function for ORFik experiment
#' @param object an ORFik experiment
#' @return number of rows in experiment (integer)
setMethod("nrow",
          "experiment",
          function(x) {
            nrow(as.data.table(as(x@listData, Class = "DataFrame")))
          }
)

#' Read ORFik experiment
#'
#' An object to massivly simplify your coding, it is
#' similar to systempipeR's 'target' table. By containing
#' filepaths and info for each library in some experiment.
#'
#' Simplest way to make is to call create.experiment on some
#' folder with libraries and see what you get. Some of the fields
#' might be needed to fill in manually. The important thing is
#' that each row must be unique (excluding filepath), that means
#' if it has replicates then that must be said explicit. And all
#' filepaths must be unique and have files with size > 0.
#' Syntax:
#' libtype (library type): rna-seq, ribo-seq, CAGE etc.
#' rep (replicate): 1,2,3 etc
#' condition: WT (wild-type), control, target, mzdicer, starved etc.
#' fraction: 18, 19 (fractinations), or other ways to split library.
#' filepath: Full filepath to file
#'
#' The file must be csv and be a valid ORFik experiment
#' @param file a .csv file following ORFik experiment style, or a
#' template data.frame from create.experiment()
#' @return an ORFik experiment
#' @export
#' @examples
#' # From file
#' \dontrun{
#' df <- read.experiment(filepath) # <- valid .csv file
#' }
#' # From (create.experiment() template)
#' template <- create.experiment(dir = system.file("extdata", "", package = "ORFik"),
#'                               exper = "ORFik", txdb = system.file("extdata",
#'                                     "annotations.gtf",
#'                                     package = "ORFik"),
#'                               viewTemplate = FALSE)
#' template$X5[6] <- "heart" # <- fix non unique row
#' # read experiment
#' df <- read.experiment(template)
read.experiment <-  function(file) {
  if (is(file, "character")) {
    info <- read.table(file, sep = ",", nrows = 3, stringsAsFactors = FALSE)
    listData <- read.csv2(file, skip = 3, header = T, sep = ",",
                          stringsAsFactors = FALSE)
  } else if(is(file, "data.frame")) {
    info <- file[1:3,]
    listData <- file[-c(1:4),]
    colnames(listData) <- file[4,]
  } else stop("file must be either character or data.frame template")


  exper <- info[1,2]
  txdb <- ifelse(is.na(info[2,2]),  "", info[2,2])
  fa <- ifelse(is.na(info[3,2]),  "", info[3,2])

  df <- experiment(experiment = exper, txdb = txdb, fafile = fa,
                   listData = listData, expInVarName = TRUE)

  validateExperiments(df)
  return(df)
}

#' Create a template for new ORFik experiment
#'
#' By using files in a folder. You will have to fill in the details
#' that were not autodetected.
#' @param dir Which directory to create experiment from
#' @param exper Short name of experiment, max 5 characters long
#' @param saveDir Directory to save experiment csv file (NULL)
#' @param types Default (bam, bed, wig), which types of libraries to allow
#' @param txdb A path to gff/gtf file used for libraries
#' @param fa A path to fasta genome/sequences used for libraries
#' @param viewTemplate run View() on template when finished, default (TRUE)
#' @return a data.frame, NOTE: this is not a ORFik experiment,
#'  only a template for it!
#' @export
#' @examples
#' template <- create.experiment(dir = system.file("extdata", "", package = "ORFik"),
#'                               exper = "ORFik", txdb = system.file("extdata",
#'                                     "annotations.gtf",
#'                                     package = "ORFik"),
#'                               viewTemplate = FALSE)
#' template$X5[6] <- "heart" # <- fix non unique row
#' # read experiment
#' df <- read.experiment(template)
create.experiment <- function(dir, exper, saveDir = NULL,
                              types = c("bam", "bed", "wig"), txdb = "",
                              fa = "", viewTemplate = TRUE) {
  if (!dir.exists(dir)) stop(paste0(dir, " is not a valid directory!"))
  files <- findLibrariesInFolder(dir, types)

  df <- data.frame(matrix(ncol = 6, nrow = length(files) + 4))
  df[4,] <- c("libtype", "stage", "rep", "condition", "fraction","filepath")
  df[5:(5+length(files)-1),6] <- files
  df[5:(5+length(files)-1),1] <- findFromPath(files)
  df[5:(5+length(files)-1),2] <- findFromPath(files, c("64cell", "sphere", "shield",
                                                       "64-cell", "Sphere", "Shield",
                                                       "2h", "4h", "6h", "8h"))
  df[5:(5+length(files)-1),3] <- findFromPath(files, c("rep1", "rep2", "rep3",
                                                       "run1", "run2", "run3",
                                                       "_r1_", "_r2_", "_r3_",
                                                       "_R1_", "_R2_", "_R3_"))
  df[5:(5+length(files)-1),4] <- findFromPath(files, c("WT", "control",
                                                       "MZ", "dicer"))
  df[1, 1:2] <- c("name", exper)
  df[2, 1:2] <- c("gff", txdb)
  df[3, 1:2] <- c("fasta", fa)
  df[is.na(df)] <- ""
  if (!is.null(saveDir))
    save.experiment(df, paste0(saveDir, exper,".csv"))
  if (viewTemplate) View(df)
  return(df)
}

#' Save experiment to disc
#' @param df an ORFik experiment data.frame
#' @param file name of file to save df as
#' @return NULL
save.experiment <- function(df, file) {
  write.table(x = df, file = file, sep = ",", row.names = F, col.names = F)
  return(NULL)
}

#' Find all candidate library types filenames
#' @param filepaths path to all files
#' @param candidates Possible names to search for.
#' @return a candidate library types (character vector)
findFromPath <- function(filepaths, candidates = c("RNA", "rna-seq", "RFP",
                                                   "RPF", "ribo-seq", "mrna",
                                                   "CAGE", "cage","LSU",
                                                   "SSU",
                                                   "ATAC", "tRNA", "SHAPE")) {
  types <- c()
  for (path in filepaths) {
    hit <- unlist(sapply(candidates, grep, x = path))
    hitRel <- unlist(sapply(candidates, grep, x = gsub(".*/", "", path)))
    type <- if(length(hit) == 1 & length(hitRel) == 0) names(hit)
    over <- hit[names(hit) %in% names(hitRel)]
    type <- ifelse(length(over) == 1, names(over), "")
    types <- c(types, gsub(pattern = "_", "", type))
  }
  return(types)
}


#' Which type of experiments?
#' @param df an ORFik experiment data.frame
#' @return NULL
libraryTypes <- function(df){
  if (is(df, "experiment")) {
    return(unique(df$libtype))
  } else if (is(df, "character") | is(df, "factor")) {
    return(gsub("_.*", x = df, replacement = ""))
  } else stop("library types must be data.frame or character vector!")
}

#' Validate ORFik experiment
#' Check for valid non-empty files etc.
#' @param df an ORFik experiment data.frame
#' @return NULL
validateExperiments <- function(df) {
  libTypes <- libraryTypes(df)
  if (!is(df, "experiment")) stop("df must be experiment!")
  if (!all((c("stage", "libtype") %in% colnames(df))))
    stop("stage, libtype and experiment must be colnames in df!")
  if (length(libTypes) == 0) stop("df have no valid sequencing libraries!")
  if (nrow(df) == 0) stop("df must have at least 1 row!")

  emptyFiles <- c()
  for (i in df$filepath) {
    emptyFiles <- c(emptyFiles, as.numeric(sapply(as.character(i),
                                                  file.size)) == 0)
  }
  if (any(is.na(emptyFiles)))
    stop(paste("File is not existing:\n",df$filepath[is.na(emptyFiles)]))
  if (any(emptyFiles)) {
    print(cbind(df[which(emptyFiles),]))
    stop("Empty files in list, see above for which")
  }
  if (length(bamVarName(df)) != length(unique(bamVarName(df))))
    stop("experiment table has non-unique rows!")
  if (length(df$filepath) != length(unique(df$filepath)))
    stop("Duplicated filepaths in experiment!")
}

#' Get variable names from experiment
#' @param df an ORFik experiment data.frame
#' @param skip.replicate a logical (FALSE), don't include replicate
#' in variable name.
#' @param skip.condition a logical (FALSE), don't include condition
#' in variable name.
#' @param skip.stage a logical (FALSE), don't include stage
#' in variable name.
#' @param skip.fraction a logical (FALSE), don't include fraction
#' @param skip.experiment a logical (FALSE), don't include experiment
#' @return NULL
#' @export
bamVarName <- function(df, skip.replicate = length(unique(df$rep)) == 1,
                       skip.condition = length(unique(df$condition)) == 1,
                       skip.stage = length(unique(df$stage)) == 1,
                       skip.fraction = length(unique(df$fraction)) == 1,
                       skip.experiment = !df@expInVarName) {
  libTypes <- libraryTypes(df)
  varName <- c()
  for (i in 1:nrow(df)) {
    varName <- c(varName, bamVarNamePicker(df[i,], skip.replicate,
                                           skip.condition, skip.stage,
                                           skip.fraction, skip.experiment))
  }
  return(varName)
}

#' Get variable name per filepath in experiment
#' @param df an ORFik experiment data.frame
#' @param skip.replicate a logical (FALSE), don't include replicate
#' in variable name.
#' @param skip.condition a logical (FALSE), don't include condition
#' in variable name.
#' @param skip.stage a logical (FALSE), don't include stage
#' in variable name.
#' @param skip.fraction a logical (FALSE), don't include fraction
#' @param skip.experiment a logical (FALSE), don't include experiment
#' @return NULL
bamVarNamePicker <- function(df, skip.replicate = FALSE,
                             skip.condition = FALSE,
                             skip.stage = FALSE, skip.fraction = FALSE,
                             skip.experiment = FALSE) {
  if(nrow(df) != 1) stop("experiment must only input 1 row")
  lib <- df$libtype
  stage <- df$stage
  cond <- df$condition
  rep <- df$rep
  frac <- df$fraction
  current <- lib
  if(!skip.condition)
    current <- paste(current, cond, sep = "_")
  if (!skip.stage)
    current <- paste(current, stage, sep = "_")
  if (!(skip.fraction | is.null(frac))) {
    if (frac != "")
      current <- paste(current, paste0("f", frac), sep = "_")
  }

  if (!(skip.replicate | is.null(rep)))
    current <- paste(current, paste0("r", rep), sep = "_")
  if (! (skip.experiment | is.null(df@experiment)))
    current <- paste(df@experiment, current, sep = "_")
  return(current)
}

#' Output bam/bed/wig files to R as variables
#'
#' Variable names defined by df
#' @param df an ORFik experiment data.frame
#' @param chrStyle the sequencelevels style (GRanges object or chr)
#' @param envir environment to save to, default (.GlobalEnv)
#' @return NULL
#' @export
outputLibs <- function(df, chrStyle = NULL, envir = .GlobalEnv) {
  dfl <- df
  if(!is(dfl, "list")) dfl <- list(dfl)

  for (df in dfl) {
    validateExperiments(df)
    libTypes <- libraryTypes(df)
    varNames <- bamVarName(df)
    message(paste0("Ouputing libraries from: ",df@experiment))
    for (i in 1:nrow(df)) { # For each stage
      message(paste(i, ": ", varNames[i]))
      if (exists(x = varNames[i], envir = envir, inherits = FALSE)) next
      reads <- ORFik:::fimport(df[i,]$filepath, chrStyle)
      assign(varNames[i], reads, envir = envir)
    }
  }
}

#' Get all bam files in folder
#' @param dir The directory to find bam, bed, wig files.
#' @param types All accepted types of bam, bed, wig files..
#' @return (character vector) All files found from types parameter.
findLibrariesInFolder <- function(dir, types) {
  types <- paste(".",types, collapse = "|", sep = "")
  files <- grep(pattern = types, x = list.files(dir, full.names = T),
                value = T)
  # Remove .bai bam index files
  bai <- -grep(pattern = ".bai", x = files)
  if (length(bai)) {
    return(files[bai])
  }

  if (length(files) == 0) stop("Found no valid files in folder")
  return(files)
}