using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogoAnimatorScript : MonoBehaviour
{
    public GameObject Bar8Container;
    public Animator Bar16Animator;
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Animator>().SetBool("Show", true);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Show16Bars()
    {
        Bar8Container.SetActive(false);
        Bar16Animator.gameObject.SetActive(true);
        Bar16Animator.SetBool("Show", true);
    }
}
