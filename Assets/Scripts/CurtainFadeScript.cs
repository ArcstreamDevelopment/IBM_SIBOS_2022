using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using UnityEngine;
using Color = UnityEngine.Color;

public class CurtainFadeScript : MonoBehaviour
{
    private Material curtainMaterial;
    private bool alphaSet = false;

    // Start is called before the first frame update
    void Start()
    {
        curtainMaterial = GetComponent<MeshRenderer>().material;
        StartCoroutine(FadeInCurtain());
    }

    // Update is called once per frame
    void Update()
    {
        if (alphaSet)
        {
            return;
        }
    }

    private IEnumerator FadeInCurtain()
    {
        float duration = 0.2f;
        for(float time = 0f; time <= duration; time += Time.deltaTime)
        {
            float newAlpha = time / duration;
            SetMaterial(newAlpha);
            yield return null;
        }
        SetMaterial(1f);
        alphaSet = true;

    }

    private void SetMaterial(float alpha)
    {
        Color newColor = curtainMaterial.color;
        newColor.a = alpha;
        curtainMaterial.color = newColor;
        GetComponent<MeshRenderer>().material = curtainMaterial;

    }
}
