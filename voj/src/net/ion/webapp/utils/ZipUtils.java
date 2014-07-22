package net.ion.webapp.utils;
 
/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * File utilities
 * 
 * @version $Revision: 691982 $
 */
public final class ZipUtils {
    /**
     * Zip up a directory
     * 
     * @param directory
     * @param zipName
     * @throws IOException
     */
    public static void zipDir(String directory, String zipName) throws IOException {
        // create a ZipOutputStream to zip the data to
        ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipName));
        String path = "";
        zipDir(directory, zos, path);
        // close the stream
        zos.close();
    }
    public static void zipDir(String directory, File zipFile) throws IOException {
        // create a ZipOutputStream to zip the data to
        ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipFile));
        String path = "";
        zipDir(directory, zos, path);
        // close the stream
        zos.close();
    }

    /**
     * Zip up a directory path
     * @param directory
     * @param zos
     * @param path
     * @throws IOException
     */
    public static void zipDir(String directory, ZipOutputStream zos, String path) throws IOException {
        File zipDir = new File(directory);
        // get a listing of the directory content
        String[] dirList = zipDir.list();
        byte[] readBuffer = new byte[2156];
        int bytesIn = 0;
        // loop through dirList, and zip the files
        for (int i = 0; i < dirList.length; i++) {
            File f = new File(zipDir, dirList[i]);
            if (f.isDirectory()) {
                String filePath = f.getPath();
                zipDir(filePath, zos, path + f.getName() + "/");
                continue;
            }
            FileInputStream fis = new FileInputStream(f);
            try {
                ZipEntry anEntry = new ZipEntry(path + f.getName());
                zos.putNextEntry(anEntry);
                bytesIn = fis.read(readBuffer);
                while (bytesIn != -1) {
                    zos.write(readBuffer, 0, bytesIn);
                    bytesIn = fis.read(readBuffer);
                }
            } finally {
                fis.close();
            }
        }
    }
    
	
	public static void main(String[] args) throws Exception{
		File tmpZipFile = File.createTempFile("Tender_", ".zip");
		ZipUtils.zipDir("C:/cd/root", tmpZipFile);

		System.out.println(tmpZipFile.getAbsolutePath());
	}

}

   