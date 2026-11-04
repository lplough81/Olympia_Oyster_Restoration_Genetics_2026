library(pophelper)
library(label.switching)
 
# ---- 1. Settings ----
input_dir <- "path/to/structure/results"   
out_dir   <- "clumpp_style_output"
dir.create(out_dir, showWarnings = FALSE)
 
# ---- 2. Read STRUCTURE runs ----
sfiles <- list.files(input_dir, full.names = TRUE)
slist  <- readQ(sfiles, filetype = "structure")
 
# ---- 3. Likelihood-based convergence check (per K) ----
tab  <- tabulateQ(slist)
summ <- summariseQ(tab)
cat("\n=== Likelihood (Ln Pr(X|K)) summary per K ===\n")
print(summ)
write.csv(summ, file.path(out_dir, "likelihood_summary.csv"), row.names = FALSE)
 
# ---- 4. Split runs by K ----
qbyk <- splitQ(slist, by = "k")
cat("\nFound K groups:", paste(names(qbyk), collapse = ", "), "\n")
 
# ---- 5. G' similarity function (mirrors CLUMPP's statistic) ----
g_stat <- function(Q1, Q2) {
  Q1 <- as.matrix(Q1); Q2 <- as.matrix(Q2)
  1 - mean(rowSums(abs(Q1 - Q2))) / 2
}
 
# ---- 6. Loop over each K: align + compute similarity matrix -----------
results <- list()
 
for (kname in names(qbyk)) {
  qk    <- qbyk[[kname]]
  nreps <- length(qk)
 
  if (nreps < 2) {
    cat(sprintf("\n[%s] only %d run(s) - skipping (need >=2 to assess convergence)\n",
                kname, nreps))
    next
  }
 
  cat(sprintf("\n=== %s (%d replicate runs) ===\n", kname, nreps))
 
  # align cluster labels across replicate runs (resolves label-switching)
  qk_aligned <- alignK(qk)
 
  # pairwise similarity matrix
  runs   <- lapply(qk_aligned, as.matrix)
  simmat <- matrix(NA, nreps, nreps, dimnames = list(names(runs), names(runs)))
  for (i in 1:nreps) {
    for (j in 1:nreps) {
      simmat[i, j] <- g_stat(runs[[i]], runs[[j]])
    }
  }
  diag(simmat) <- NA
 
  avg_sim <- mean(simmat, na.rm = TRUE)
  min_sim <- min(simmat, na.rm = TRUE)
 
  cat(sprintf("Average pairwise similarity (H'): %.4f\n", avg_sim))
  cat(sprintf("Minimum pairwise similarity:      %.4f\n", min_sim))
 
  write.csv(simmat, file.path(out_dir, paste0(kname, "_similarity_matrix.csv")))
 
  hc <- hclust(as.dist(1 - simmat), method = "average")
  pdf(file.path(out_dir, paste0(kname, "_dendrogram.pdf")), width = 5, height = 4)
  plot(hc, main = paste(kname, "- run similarity clustering"),
       xlab = "Replicate run", sub = "")
  dev.off()
 
  results[[kname]] <- list(
    aligned = qk_aligned,
    simmat  = simmat,
    avg_sim = avg_sim,
    min_sim = min_sim,
    n_reps  = nreps
  )
}
 
# ---- 7. Overall summary table across all K ----
summary_table <- do.call(rbind, lapply(names(results), function(k) {
  data.frame(
    K               = k,
    n_reps          = results[[k]]$n_reps,
    mean_similarity = round(results[[k]]$avg_sim, 4),
    min_similarity  = round(results[[k]]$min_sim, 4)
  )
}))
 
cat("\n=== Convergence summary across all K ===\n")
print(summary_table)
write.csv(summary_table, file.path(out_dir, "convergence_summary.csv"), row.names = FALSE)
 
# ---- 8. Aligned barplots per K ----
for (kname in names(results)) {
  plotQ(results[[kname]]$aligned,
        imgoutput      = "join",
        exportpath     = out_dir,
        outputfilename = paste0(kname, "_aligned_barplot"),
        imgtype        = "pdf")
}
