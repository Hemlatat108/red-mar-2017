package bootcamp

import org.scalatest.FlatSpec

class MeasurementTest extends FlatSpec {

  "A String" should "Parse into a measurement" in {
    val str = "4baaffa1-bd3c-4fba-9be0-5734a0ea0196,2,1,71,1490899038154,0.25294615647429053,0.8163441187270423,0.4671195585443785"

    val meas = MeasurementString.unapply(str)

    assert("4baaffa1-bd3c-4fba-9be0-5734a0ea0196" === meas.get.measurement_id)
    assert(2 === meas.get.detector_id)
    assert(1 === meas.get.galaxy_id)
    assert(1490899038154L === meas.get.measurement_time)
  }

}
