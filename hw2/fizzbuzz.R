fizzbuzz <- function(input){
  # if input is not a vector, return error
  if (is.vector(input) == FALSE) warning("Input should be a vector.")
  # for loop to iterate through numbers in vector object
  for (number in input){
    # if number is not an integer, return error
    if (is.integer(number) == FALSE)
      warning("Item in input should be an integer.")
    # test if number is multiple of 3 and 5
    if (number %% 3 == 0 & number %% 5 == 0){
      # if number is equal to 0, print 0 and skip rest of iteration
      if (number == 0){
        print(0)
        next
        # otherwise print FizzBuzz and now skip rest of iteration
      } else {
        print("FizzBuzz")
        next
      }
    }
    # test if number is only multiple of 3
    if (number %% 3 == 0){
      print("Fizz")
    }
    # test if number is only multiple of 5
    if (number %% 5 == 0){
      print("Buzz")
    }
    # test if number is neither multiple of 3 and 5
    if (number %% 5 != 0 & number %% 3 != 0){
      print(number)
    }
  }
}

# create vector of integer numbers
list_1 <- c(3L, 15L, 5L, 9L, 7L, 0L)
list_2 <- list(12L, 25L, 4L)
fizzbuzz(list_1)
fizzbuzz(list_2)
fizzbuzz(3)
fizzbuzz("cat")