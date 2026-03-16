import qupath.lib.gui.tools.MeasurementExporter
import qupath.lib.objects.PathDetectionObject


def project = getProject()
def images = project.getImageList()

def exportDirEnv = System.getenv('QUPATH_EXPORT_DIR')
def exportDir = (exportDirEnv != null && !exportDirEnv.trim().isEmpty()) ? exportDirEnv : PROJECT_BASE_DIR

new File(exportDir).mkdirs()

println "Found ${images.size()} images in project: ${project.getName()}"
println "Export directory: ${exportDir}"
images.each { println "Image: ${it.getImageName()}" }

if (images.isEmpty()) {
    print "No images found in project – nothing to export."
    return
}

def separator = ','
def exportType = PathDetectionObject.class

int idx = 0
int success = 0
int fail = 0
def start = System.currentTimeMillis()

for (entry in images) {
    idx++
    def name = entry.getImageName()
    println "[${idx}/${images.size()}] Starting export for image: ${name} at ${new Date()}"

    try {
        def safeName = name.replaceAll("[^a-zA-Z0-9._-]", "_")
        def outputPath = buildFilePath(exportDir, safeName + ".csv")
        def outputFile = new File(outputPath)
        if (outputFile.exists()) outputFile.delete()

        new MeasurementExporter()
            .imageList([entry])
            .exportType(exportType)
            .separator(separator)
            .exportMeasurements(outputFile)

        success++
        println "[${idx}/${images.size()}] Finished exporting: ${name} to ${outputPath}"
    } catch (Throwable t) {
        println "[${idx}/${images.size()}] Failed exporting ${name}: ${t.getMessage()}"
        fail++
    }

    System.gc()
}

def dur = (System.currentTimeMillis() - start) / 1000.0
println "Export complete: ${success} succeeded, ${fail} failed, output folder: ${exportDir} (took ${String.format('%.1f', dur)} s)"
