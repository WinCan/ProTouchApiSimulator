# Scripts for version publication to Amazon S3

Language: Python3
Libraries: boto3, ProgressBar

## Before you run

Make sure that you have: 
* aws credentials set on your PC
* aws cli installed 

## Scripts description

* publish.py - publishes simulator package to production/ folder on aws. Input argument:
    * Path to package file
	
Example usage:
```
python publish.py ./ProTouchApiSimulator.zip
```


