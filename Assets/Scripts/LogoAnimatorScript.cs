using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogoAnimatorScript : MonoBehaviour
{
    public GameObject Curtain;
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Animator>().SetBool("Show", true);
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void ShowCurtain()
    {
        Curtain.SetActive(true);
    }

    public void CloseLines()
    {
        gameObject.SetActive(false);
    }

}
