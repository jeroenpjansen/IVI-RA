% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-data.R
\name{get_input_data}
\alias{get_input_data}
\title{Input data for simulation}
\usage{
get_input_data(patdata, x_mort = NULL, x_ttd = NULL, model_structure)
}
\arguments{
\item{patdata}{Matrix of patient data. Must contain variables generated from \link{sample_pats}:
 'age' for age, 'haq0' for baseline HAQ, 'male' as a indicator equal to
1 if the patient is male and 0 if female, 'weight' for patient weight, and 'prev_dmards' 
for number of previous DMARDs.}

\item{vars_mort}{A matrix with each column a variable used to adjust mortality.}

\item{vars_ttd}{The design matrix for time to treatment discontinuation.
@param model_structure An object of class \code{model_structure} generated from 
\link{select_model_structure}.}
}
\value{
A list containing the following data inputs:
\describe{
  \item{n}{Number of simulated patients}
  \item{haq0}{A vector of patient HAQ at baseline.}
  \item{age}{A vector of patient age at baseline.}
  \item{male}{A vector of patient gender (1 = male, 0 = female).}
  \item{prev.dmards}{A vector of the number of previous DMARDs}
  \item{x.mort}{Design matrix for mortality adjustment with odds ratios}
  \item{x.ttd}{Design matrix for treatment duration.}
}
}
\description{
Generate data inputs for the IPS.
}