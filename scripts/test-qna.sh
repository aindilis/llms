#!/bin/bash

./qna-over-text.pl -t 8192 -i "Consider the following text, please answer the question that follows it: < < < " -f "<REDACTED>" -d " > > > The question that follows is: < < < " -Q "<REDACTED>" -c " > > > Please use the original text to answer the question here: "
