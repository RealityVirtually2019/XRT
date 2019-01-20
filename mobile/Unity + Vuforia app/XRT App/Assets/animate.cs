using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class animate : MonoBehaviour
{
    // Start is called before the first frame update
    private Animation myAnimationComponent;

    void Start()
    {
        myAnimationComponent = GetComponent<Animation>();
        myAnimationComponent.Play("Take001");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
