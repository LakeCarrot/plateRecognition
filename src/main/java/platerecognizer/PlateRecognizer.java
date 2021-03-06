/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package platerecognizer;
import com.openalpr.jni.Alpr;
import com.openalpr.jni.AlprPlate;
import com.openalpr.jni.AlprPlateResult;
import com.openalpr.jni.AlprResults;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import java.lang.Thread;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import edgeOffloading.OffloadingGrpc;
import edgeOffloading.OffloadingOuterClass.OffloadingRequest;
import edgeOffloading.OffloadingOuterClass.OffloadingReply;

public class PlateRecognizer {
	static ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
	public void recognize(String filename, long dataSize) {
		Alpr alpr = new Alpr("us", "openalpr.conf", "runtime_data");
		// Set top N candidates returned to 20
		//alpr.setTopN(20);
		while(true) {
			try {
				long begin = System.currentTimeMillis();
				alpr.recognize(filename);
				long end = System.currentTimeMillis();
				double currentRate = dataSize/(end-begin);
				System.out.println("" + dataSize); 
				updateInfo(currentRate);
			} catch(Exception e) {
				System.out.println("Something wrong!");
				continue;
			}
		}
	}
	private void updateInfo(double rate) {
		ManagedChannel mChannel;
		mChannel = ManagedChannelBuilder.forAddress("172.28.142.176", 50050).usePlaintext(true).build();
		OffloadingGrpc.OffloadingBlockingStub stub = OffloadingGrpc.newBlockingStub(mChannel);
		String hostIP = System.getenv("HOSTIP");
		OffloadingRequest message = OffloadingRequest.newBuilder().setMessage(hostIP + ":" + "plate" + ":" + Double.toString(rate)).build();
		OffloadingReply reply = stub.startService(message);
	}
}
