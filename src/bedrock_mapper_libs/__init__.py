import os
import subprocess

from typing import Self

from rv_script_lib import ScriptBase


class BedrockMapper(ScriptBase):

    PARSER_VERBOSITY_CONFIG = "count"

    BLUEMAP_CLI_JAR = os.getenv("BLUEMAP_CLI_JAR")
    CHUNKER_CLI_JAR=os.getenv("CHUNKER_CLI_JAR")

    def convert_world(self: Self, src_dir: str, dest_dir: str, dest_format: str):

        cmd = [
            "java",
            "-jar",
            self.CHUNKER_CLI_JAR,
            "-i",
            src_dir,
            "-f",
            dest_format,
            "-o",
            dest_dir
        ]

        subprocess.run(cmd)

    def runJob(self: Self):
        pass
