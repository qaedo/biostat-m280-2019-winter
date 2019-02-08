#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
void rcpp_fizzbuzz(NumericVector input){
  for (int i = 0; i < input.length(); i++) {
    bool lineprinted = FALSE;
    if (fmod(input[i], 3.0) == 0.0) {  
      Rprintf("Fizz");
      lineprinted = TRUE;
    }
    if (fmod(input[i], 5.0) == 0.0) {
      Rprintf("Buzz");
      lineprinted = TRUE;
    }
    if (lineprinted == TRUE) {
      Rcout << "\n";
    } else {
      Rcout << input[i] << "\n";
    }
  }
}