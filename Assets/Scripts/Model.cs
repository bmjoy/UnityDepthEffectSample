using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Model : MonoBehaviour {
    float degreesPerSecond = 10f; // angular speed
    Vector3 axis = new Vector3(0f,1f,0f);
    void Update()
    {
        Quaternion q = Quaternion.AngleAxis(degreesPerSecond * Time.deltaTime, axis);
        transform.localRotation = transform.localRotation * q;
    }
}
