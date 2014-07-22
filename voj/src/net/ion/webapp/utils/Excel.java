package net.ion.webapp.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;

public class Excel {
	private HSSFWorkbook wb;
	private HSSFSheet sheet;
	private Map mCellStyle = null;
	private Map<Integer, HSSFRow> rows;

	public Excel(String sheetName) {
		wb = new HSSFWorkbook();
		sheet = wb.createSheet(sheetName);
		mCellStyle = new HashMap();
		rows = new HashMap<Integer, HSSFRow>();

	}

	public void addCell(int rownum, int colnum, Object val, int align,
			int fontSize, int width, boolean isBold, boolean isBorder,
			boolean isForeground, String format, boolean isFormula) {
		boolean isStyle = false;
		// HSSFRow row = sheet.isRowBroken(rownum) ? sheet.getRow(rownum) :
		// sheet.createRow((short) rownum);
		HSSFRow row = rows.get(rownum);
		row = row == null ? sheet.createRow((short) rownum) : row;
		rows.put(rownum, row);

		HSSFCell cell = row.createCell((short) colnum);
		// cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		String key = align + ":" + fontSize + ":" + width + ":" + isBold + ":"
				+ isBorder + ":" + isForeground + ":" + format;
		HSSFCellStyle cellStyle = (HSSFCellStyle) mCellStyle.get(key);

		if (cellStyle == null) {
			cellStyle = wb.createCellStyle();
			mCellStyle.put(key, cellStyle);
			isStyle = true;
		}
		wb.createCellStyle();
		cell.setCellStyle(cellStyle);

		if (isStyle) {
			setFormat(cell, format);

			setAlignment(cell, (short) align);
			setFont(cell, fontSize, isBold);
			if (width > -1)
				sheet.setColumnWidth((short) colnum, (short) (width * 250));

			if (isForeground)
				setFillForegroundColor(cell);

			if (isBorder)
				setBorderStyle(cell);
		}
		if (isFormula) {
			cell.setCellFormula(val.toString());
		} else {
			if (val instanceof BigDecimal) {
				BigDecimal bd = (BigDecimal) val;

				cell.setCellValue(bd.doubleValue());
			}else if (val instanceof Integer)  {
				cell.setCellValue(Integer.parseInt(val.toString()));
			}else if (val instanceof Date)  {
				cell.setCellValue((Date) val);
			}else if (val instanceof Timestamp)  {
				cell.setCellValue((Timestamp) val);
			}else if (val == null)  {
				cell.setCellValue("");
			}else{
				cell.setCellValue(val.toString());
			}
		}
	}

	public void addCell(int rownum, int colnum, Object val, int align,
			int fontSize ,int width,boolean isBold,boolean isBorder, boolean isForeground) {
		addCell(rownum, colnum, val, align, fontSize, width, isBold, isBorder,
				isForeground, "", false);
	}

	public void addCell(int rownum, int colnum, Object val, int align,
			int fontSize,int width,boolean isBold, boolean isBorder, boolean isForeground, String format) {
		addCell(rownum, colnum, val, align, fontSize, width, isBold, isBorder,
				isForeground, format, false);
	}

	public void addCell(int rownum, int colnum, Object val, int align,
			int width, boolean isBorder, boolean isForeground, String format,
			boolean isFormula) {
		addCell(rownum, colnum, val, align, 11, width, false, isBorder,
				isForeground, format, isFormula);
	}

	public void addCell(int rownum, int colnum, Object val, int align,
			int width,boolean isBold, boolean isBorder, boolean isForeground, boolean isFormula) {
		addCell(rownum, colnum, val, align, 11, width, isBold, isBorder,
				isForeground, "", isFormula);
	}

	public void addCell(int rownum, int colnum, Object val, int align,
			int width, String format) {
		addCell(rownum, colnum, val, align, 11, width, false, true, false,
				format, false);
	}

	public void addCell(int rownum, int colnum, Object val, int align,
			String format) {
		addCell(rownum, colnum, val, align, 11, -1, false, true, false, format,
				false);
	}

	public void addMergedRegion(int startRow, int startCol, int endRow,
			int endCol) {
		sheet.addMergedRegion(new Region(startRow, (short) startCol, endRow,
				(short) endCol));
	}

	public void write(HttpServletResponse response) {
		try {
			write(response.getOutputStream());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void write(OutputStream os) {
		try {
			wb.write(os);
			os.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Creates a cell and aligns it a certain way.
	 * 
	 * @param wb
	 *            the workbook
	 * @param row
	 *            the row to create the cell in
	 * @param column
	 *            the column number to create the cell in
	 * @param align
	 *            the alignment for the cell.
	 */
	private void setAlignment(HSSFCell cell, short align) {

		HSSFCellStyle style = cell.getCellStyle();

		style.setAlignment(align);
		cell.setCellStyle(style);

	}

	private void setFillForegroundColor(HSSFCell cell) {

		HSSFCellStyle style = cell.getCellStyle();

		style.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		cell.setCellStyle(style);

	}

	private void setBorderStyle(HSSFCell cell) {

		HSSFCellStyle style = cell.getCellStyle();

		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBottomBorderColor(HSSFColor.BLACK.index);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setLeftBorderColor(HSSFColor.BLACK.index);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setRightBorderColor(HSSFColor.BLACK.index);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setTopBorderColor(HSSFColor.BLACK.index);
		cell.setCellStyle(style);

	}

	private void setFormat(HSSFCell cell, String formatStr) {
		if (formatStr.equals(""))
			return;
		HSSFCellStyle style = cell.getCellStyle();

		HSSFDataFormat format = wb.createDataFormat();
		style.setDataFormat(format.getFormat(formatStr));

		cell.setCellStyle(style);

	}

	private void setFont(HSSFCell cell, int size, boolean isBold) {

		HSSFCellStyle style = cell.getCellStyle();

		HSSFFont font = wb.createFont();
		font.setFontHeightInPoints((short) size);
		// font.setFontName("돋움");
		// font.setItalic(true);
		// font.setStrikeout(true);
		if (isBold) {
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		}
		style.setFont(font);

		cell.setCellStyle(style);

	}

	public static void main(String[] args) {
		String fileName = "c:/temp/sss.xls";
		FileOutputStream fos = null;

		Excel xls = new Excel("test");

		xls.addCell(0, 0, "test", HSSFCellStyle.ALIGN_CENTER, 15, -1, true,
				false, false, "", false);
		xls.addMergedRegion(0, 0, 0, 10);

		for (int i = 2; i < 1000; i++) {
			for (int j = 1; j < 10; j++) {
				if (i == 2) {
					xls.addCell(i, j, "" + i, HSSFCellStyle.ALIGN_RIGHT,11, 10,false,
							true, true);
				} else if (i == 3) {
					xls.addCell(i, j, "" + i, HSSFCellStyle.ALIGN_RIGHT,11, 10,false,
							true, false);
				} else {
					xls.addCell(i, j, "" + i, HSSFCellStyle.ALIGN_CENTER,11, 10,false,
							true, false);

				}
			}
			// xls.addCell(i, 10, "sum(B4:J4)", HSSFCellStyle.ALIGN_CENTER, 10,
			// true, false);
		}

		try {
			fos = new FileOutputStream(new File(fileName));
			xls.write(fos);
			fos.close();
			System.out.println("end");
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
