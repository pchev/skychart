#!/bin/bash

fpc filtervsx.pp
if [[ $? != 0 ]]; then exit 1; fi

./filtervsx

