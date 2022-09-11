using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogoAnimatorScript : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Animator>().SetBool("Show", true);
    }

    // Update is called once per frame
    void Update()
    {

    }

}
