#!/usr/bin/env node
import * as cdk from '@aws-cdk/core';
import { Lab8Stack } from '../lib/lab8-stack';

const app = new cdk.App();
new Lab8Stack(app, 'Lab8Stack');
