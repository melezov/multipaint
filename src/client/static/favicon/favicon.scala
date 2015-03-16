/** This is free and unencumbered software released into the public domain.
  * The script will create a 16x16x4bpp icon based on color data from a source PNG.
  *
  * Another not-invented-here utility script by Marko Elezovic (https://github.com/melezov),
  * because it seems that the entire world doesn't know how to create a proper icon.
  *
  * ImageMagick, Any2Icon, and a dozen on-line converters insist that there is no such thing
  * as a 4bpp icon with a custom palette and/or keep dragging in the entire system color table.
  *
  * Simply mind-boggling.
  */

val in = "favicon.png"
val out = "favicon.ico"

import java.awt.image.IndexColorModel
import java.io.{ File, FileOutputStream }
import javax.imageio.ImageIO
import language.reflectiveCalls

class IconWriter(out: String) {
  private val fos = new FileOutputStream(out)

  def writeByte(b: Byte) =
    fos.write(b)

  def writeWord(w: Short) = {
    fos.write(w)
    fos.write(w >>> 8)
  }

  def writeDword(d: Int) = {
    fos.write(d)
    fos.write(d >>> 8)
    fos.write(d >>> 16)
    fos.write(d >>> 24)
  }
}

val os = new IconWriter(out)

// ICONDIR
os.writeWord(0) // idReserved - Reserved (must be 0)
os.writeWord(1) // idType     - Resource Type (1 for icons)
os.writeWord(1) // idCount    - How many images?

// ICONDIRENTRY
os.writeByte(16) // bWidth         - Width, in pixels, of the image
os.writeByte(16) // bHeight        - Height, in pixels, of the image
os.writeByte(16) // bColorCount    - Number of colors in image (0 if >=8bpp)
os.writeByte(0) // bReserved      - Reserved (must be 0)
os.writeWord(1) // wPlanes        - Color Planes
os.writeWord(4) // wBitCount      - Bits per pixel
os.writeDword(296) // dwBytesInRes   - How many bytes in this resource?
os.writeDword(22) // dwImageOffset  - Where in the file is this image?

// BITMAPINFOHEADER
os.writeDword(40) // biSize           - The number of bytes required by the structure.
os.writeDword(16) // biWidth          - The width of the bitmap, in pixels.
os.writeDword(32) // biHeight         - The height of the bitmap, in pixels.
os.writeWord(1) // biPlanes         - The number of planes for the target device. This value must be set to 1.
os.writeWord(4) // biBitCount       - The number of bits-per-pixel.
os.writeDword(0) // biCompression    - The type of compression for a compressed bottom-up bitmap (0 = BI_RGB)
os.writeDword(192) // biSizeImage      - The size, in bytes, of the image.
os.writeDword(0) // biXPelsPerMeter  - The horizontal resolution, in pixels-per-meter, of the target device for the bitmap.
os.writeDword(0) // biYPelsPerMeter  - The vertical resolution, in pixels-per-meter, of the target device for the bitmap.
os.writeDword(16) // biClrUsed        - The number of color indexes in the color table that are actually used by the bitmap.
os.writeDword(0) // biClrImportant   - The number of color indexes that are required for displaying the bitmap. If this value is zero, all colors are required.

// RGBQUAD[]
val img = ImageIO.read(new File(in))
val icm = img.getColorModel.asInstanceOf[IndexColorModel]
val palette = new Array[Int](16)
icm.getRGBs(palette)
palette foreach { col => os.writeDword(col & 0xffffff) }

// XOR mask
val buffer = new Array[Byte](16 * 16)
img.getData.getDataElements(0, 0, 16, 16, buffer)

for {
  y <- 15 to 0 by -1
  x <- 0 to 15 by 2
} {
  val index = (y * 16) + x
  val px0 = buffer(index)
  val px1 = buffer(index + 1)
  val px = (px0 << 4) | px1
  os.writeByte(px.toByte)
}

// AND mask
for (y <- 15 to 0 by -1) {
  // punch transparent 1x1 px holes in the 4 corners
  val px = if (y == 15 || y == 0) 0x0180 else 0
  os.writeDword(px) // 32 bit padding is required (DWORD boundary)
}

// shutdown / flush & close
sys.exit(0)
