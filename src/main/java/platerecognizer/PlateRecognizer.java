/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package platerecognizer;
import com.openalpr.jni.Alpr;
import com.openalpr.jni.AlprPlate;
import com.openalpr.jni.AlprPlateResult;
import com.openalpr.jni.AlprResults;

import java.lang.Thread;

public class PlateRecognizer {
		private Alpr alpr;
		public void recognize() {
			alpr = new Alpr("us", "openalpr.conf", "runtime_data");
			// Set top N candidates returned to 20
			alpr.setTopN(20);

			// Set pattern to Maryland
			alpr.setDefaultRegion("md");
			System.out.println("Start to recognize");
			AlprResults results = null;
			System.out.println("Ready to recognize");

			try {
				results = alpr.recognize("1.jpg");
			} catch (Exception e) {
				Thread.currentThread().interrupt();
			}
			System.out.format("  %-15s%-8s\n", "Plate Number", "Confidence");
			for (AlprPlateResult result : results.getPlates())
			{
				for (AlprPlate plate : result.getTopNPlates()) {
					if (plate.isMatchesTemplate())
						System.out.print("  * ");
					else
						System.out.print("  - ");
					System.out.format("%-15s%-8f\n", plate.getCharacters(), plate.getOverallConfidence());
				}
			}
			alpr.unload();
		}
}
