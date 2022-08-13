#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import subprocess
import re
from pathlib import Path
import argparse

def generate_csc_rsp(rsp, netcore_app_ref_dir, windows_sdk_ref_dir, windows_app_sdk_dir, uwp_version):
    with open(rsp, 'w') as f:
        uwp_versions = uwp_version.split('.')
        f.writelines(f'/reference:"{path}"\n' for path in windows_app_sdk_dir.glob(f'lib/net5.0-windows{uwp_versions[0]}.{uwp_versions[1]}.{uwp_versions[2]}.0/*.dll'))
        f.writelines(f'/reference:"{path}"\n' for path in netcore_app_ref_dir.glob(f'ref/*/*.dll'))
 
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('rspfile', type=str)
    parser.add_argument('--netcore-app-ref-dir', type=Path, required=True)
    parser.add_argument('--windows-app-sdk-dir', type=Path, required=True)
    parser.add_argument('--uwp-version', type=str, required=True, choices=['10.0.17763', '10.0.18362'])
    args = parser.parse_args()

    windows_sdk_dir = os.environ.get("WindowsSdkDir")
    windows_sdk_lib_version = os.environ.get("WindowsSDKLibVersion")
    if windows_sdk_dir is None or windows_sdk_lib_version is None:
        sys.exit()
    
    windows_sdk_ref_dir = Path(windows_sdk_dir, "References", windows_sdk_lib_version)

    generate_csc_rsp(args.rspfile, args.netcore_app_ref_dir, windows_sdk_ref_dir, args.windows_app_sdk_dir, args.uwp_version)
