*qaedo* (Please write your name)


### Overall Grade: 90/110
### Quality of report: 10/10

-   Is the homework submitted (git tag time) before deadline?  

	Yes. `Jan 25, 2019, 8:33 PM PST`       

-   Is the final report in a human readable format html? 

    Yes. `html`.

-   Is the report prepared as a dynamic document (R markdown) for better reproducibility?

    Yes. `Rmd`.

-   Is the report clear (whole sentences, typos, grammar)? Do readers have a clear idea what's going on and how are results produced by just reading the report? 

	 Yes. 

### Correctness and efficiency of solution: 49/60

-   Q1 (10/10)

-   Q2 (17/20)

	\#5. (-3 pts) Following lines do not count how many times each value of `borough` appears. Rather, it is searching the entire file. 
	
	```
	for value in "${list[@]}"
  	  do
       echo $value
       grep -wo $value /home/m280data/NYCHVS/NYCHVS_1991.csv | wc -l
   done
	```
	
	You may use something like
	
	```bash 
	tail -n +3 /home/m280data/NYCHVS/NYCHVS_1991.csv | 
		awk -F, '{print $2}' | sort | uniq -c
	```

	
-   Q3 (15/15)

	
-  Q4 (7/15)

	\#1. (-2 pts) Use `rt` to generate random values from the `t` distribution with appropriate degrees of freedom. 

	\#2. (-2 pts) Write a bash script that runs `autoSim.R` so it will write output to files. 
	
	\#3. (-4 pts) 
	-  Print table in the format provided. 
	-  MSE values do not match with `N` and `Method`.
	-	Table looks crude. Try using `kable` for printing table. 

  
 
### Usage of Git: 8/10

-   Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch? 

    Yes. 

-   Are there enough commits? Are commit messages clear? (-2 pts)

    5 commits for hw1 in `develop` branch. **Make sure** to start version control from the very beginning of a project. Make as many commits as possible during the process. 

                  
-   Is the hw1 submission tagged? 

	Yes. 

-   Are the folders (`hw1`, `hw2`, ...) created correctly? 

    Yes.
  
-   Do not put a lot auxiliary files into version control. 

	Yes. 
	
### Reproducibility: 8/10

-   Are the materials (files and instructions) submitted to the `master` branch sufficient for reproducing all the results? Just click the `knit` button will produce the final `html` on teaching server? (-2 pts)

	- `eval=FALSE` in your code chunks 
  	prevents displaying output. Either print output or write answers. 
 Make sure your collaborators can easily run your code.   	
 	- `"~/biostat-m280-2019-winter/hw1/"`

 	- Include `bash` script that runs your files `autoSim.R`, `outputSim.R`, ... 
	
-   If necessary, are there clear instructions, either in report or in a separate file, how to reproduce the ressults?

    Yes.

### R code style: 15/20

-   [Rule 3.](https://google.github.io/styleguide/Rguide.xml#linelength) The maximum line length is 80 characters.  (-2 pts) 

	Some violations:
	- `outputSim.R`: line 3, 55, 57
	
-   [Rule 4.](https://google.github.io/styleguide/Rguide.xml#indentation) When indenting your code, use two spaces.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place spaces around all binary operators (=, +, -, &lt;-, etc.).  (-1 pt)

	Some violations:
	- `runSim.R`: line 47, 48
		
-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place a space before a comma, but always place one after a comma. (-2 pts) 

	Some violations:
	- `outputSim.R`: line 53, 55, 57, 59, 61 
	
	
-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Place a space before left parenthesis, except in a function call.

-   [Rule 5.](https://google.github.io/styleguide/Rguide.xml#spacing) Do not place spaces around code in parentheses or square brackets.
