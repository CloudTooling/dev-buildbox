#!/usr/bin/env bash

bats --report-formatter junit test/shell/*.bats --print-output-on-failure --output reports
