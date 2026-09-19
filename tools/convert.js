import { convertPNGToVTF, VTF_FORMATS } from 'png-to-vtf';
import { readdir, readFile } from 'fs/promises';
import { join, basename, extname, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const designDir = join(__dirname, '..', 'design', 'processed');
const outputDir = join(__dirname, '..', 'materials', 'card_engine', 'expansions', 'ce_expansion_beastbound');

const isPowerOfTwo = n => n > 0 && (n & (n - 1)) === 0;
const floorPowerOfTwo = n => 2 ** Math.floor(Math.log2(n));

// PNG IHDR chunk: width and height are big-endian uint32s at byte offsets 16 and 20
async function readPNGSize(path) {
  const buffer = await readFile(path);
  return { width: buffer.readUInt32BE(16), height: buffer.readUInt32BE(20) };
}

const files = await readdir(designDir);
const pngFiles = files.filter(file => extname(file).toLowerCase() === '.png');

console.log(`Found ${pngFiles.length} PNG files to convert...`);

for (const pngFile of pngFiles) {
  const inputPath = join(designDir, pngFile);
  const outputFile = basename(pngFile, '.png') + '.vtf';
  const outputPath = join(outputDir, outputFile);

  const { width, height } = await readPNGSize(inputPath);
  const options = {};

  // Square images that are not a power of two are scaled down to the nearest power of two
  if (width === height && !isPowerOfTwo(width)) {
    const size = floorPowerOfTwo(width);
    options.width = size;
    options.height = size;
    console.log(`Converting ${pngFile} -> ${outputFile} (scaling ${width}x${height} -> ${size}x${size})`);
  } else {
    console.log(`Converting ${pngFile} -> ${outputFile}`);
  }

  await convertPNGToVTF(inputPath, outputPath, options);
}

console.log('Done!');
